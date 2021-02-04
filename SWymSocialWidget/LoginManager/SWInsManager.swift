//
//  SWInsManager.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/3.
//

import UIKit
import NoticeObserveKit
import GRDB
import SwiftyJSON
import Kingfisher


extension Notice.Names {
    static let fetchUserDetailInfoSuccess =
        Notice.Name<Any?>(name: "fetchUserDetailInfoSuccess")
    static let logoutCurrentUserAccount =
    Notice.Name<Any?>(name: "logoutCurrentUserAccount")
}

 

class InnerUserProfileInfo: NSObject, Codable, DatabaseProtocol {
    var avatarUrl: String?
    var username: String?
    var fullname: String?
    var userid: Int? // pk == userid
}

class InnerUserLoginModel: NSObject, Codable, DatabaseProtocol {
    var userProfileInfo : InnerUserProfileInfo = InnerUserProfileInfo()
    var cookieStr: String?
    var cookieDict: [String: String]?
    var loginType: String = ""
    
}



class InnerUserManager: NSObject, Codable {
    static let `default` = InnerUserManager()
    var currentUserLoginModel: InnerUserLoginModel?
    var currentUserInfo: InnerOriginal?
    
    var currentIconImageData: Data?
    
    
}

extension InnerUserManager  {
    func loadCurrentUserDetailInfo(completion: @escaping ((Bool)->Void)) {
         
        let currentUserName = InnerUserManager.default.currentUserLoginModel?.userProfileInfo.username
        var currentInnnerCookies: InnerCookies?
        
        if InnerUserManager.default.currentUserLoginModel?.loginType == "WEB" {
            if let cookieDict = InnerUserManager.default.currentUserLoginModel?.cookieDict {
                currentInnnerCookies = cookieDict.cookiesDictToModel_pi()
            }
        } else {
            if let cookieStr = InnerUserManager.default.currentUserLoginModel?.cookieStr {
                currentInnnerCookies = cookieStr.convertCookies()
            }
        }
        
        if let currentUserName_t = currentUserName, let currentInnnerCookies_t = currentInnnerCookies {
            UserDetailInfo.default.loadUserDetailInnerOriginal(userName: currentUserName_t, cookies: currentInnnerCookies_t) { (scucess, errorMessage) in
                debugPrint("get user info success = \(true)")
                 
                Notice.Center.default.post(name: .fetchUserDetailInfoSuccess, with: nil)
                completion(true)
            }
        } else {
//            HUD.error("no user login info")
            completion(false)
        }
    }
}

extension InnerUserManager {
    func loadCurrentUserLoginModelFromDB(completion: @escaping ((Bool)->Void)) {
        InnerDBManager.default.selectUserList {[weak self] (userModelList) in
            debugPrint("userModelList = \(userModelList.count)")
            guard let `self` = self else {return}
            currentUserLoginModel = userModelList.first
            self.loadCurrentUserDetailInfo(completion: completion)
        }
    }
    
    
    func logoutCurrentAccount() {
        currentUserLoginModel = nil
        currentUserInfo = nil
        Notice.Center.default.post(name: .logoutCurrentUserAccount, with: nil)
    }
    
    func saveAndUpdateCurrentUserInfoToDB() {
        // save InnerUserLoginModel
        if let userLoginInfo = currentUserLoginModel {
            InnerDBManager.default.insertUserLoginInfo(info: userLoginInfo) { (success) in
                debugPrint("save to db \(success)")
            }
        }
        
    }
    
}




class UserDetailInfo {
    static let `default` = UserDetailInfo()
    func loadUserDetailInnerOriginal(userName: String, cookies: InnerCookies, completion: @escaping ((Bool, String?)->Void))  {
        HUD.show()
        Request.fireDetail(name: userName, cookies: cookies) { result in
            HUD.hide()
            switch result {
            case let .success(origin):
                debugPrint("success")
                InnerUserManager.default.currentUserInfo = origin
                InnerUserManager.default.currentUserInfo?.cookies = cookies
                if let profileUrl = origin.profilePicUrl {
                    InnerUserManager.default.currentIconImageData = nil
                    KingfisherManager.shared.downloader.downloadImage(with: profileUrl, options: nil) { (result) in
                        switch result {
                        case let .success(image):
                            InnerUserManager.default.currentIconImageData = image.image.jpegData(compressionQuality: 0.8)
                            return
                        case let .failure(error):
                            return
                        default:
                            return
                        }
                    }
                    
                } else {
                    InnerUserManager.default.currentIconImageData = nil
                }
                
                
                completion(true, nil)
            case let .failure(error):
                HUD.error(error.errorDescription)
                completion(false, error.errorDescription)
            }
        }
    }
}

 


public struct InnerCookies: Codable, Equatable {
    var cookieString: String?
    var dsUser: String?
    var shbid: String?
    var shbts: String?
    var csrftoken: String?
    var rur: String?
    var mid: String?
    var dsUserId: String?
    var urlgen: String?
    var sessionid: String?
    private enum CodingKeys: String, CodingKey {
        case dsUser = "ds_user"
        case shbid
        case shbts
        case csrftoken
        case rur
        case mid
        case dsUserId = "ds_user_id"
        case urlgen
        case sessionid
        case cookieString
    }
}

struct InnerAPIUserInfo: Codable {
    var username: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        
    }
}


public struct InnerOriginal: YAJSONObject, Equatable {
    
    public var jsonData: JSON?
    public var cookies: InnerCookies?

    public var foreverCount: Int? {
        return FireOriginalUserJSON?["edge_fo\("llow")ed_by"]["count"].int
    }
    
    public var foreveringCount: Int? {
        return FireOriginalUserJSON?["edge_fo\("llow")"]["count"].int
    }
    
    var FireOriginalUserJSON: JSON? {
        let value = jsonData?["user"]
        return value
    }
    
    public var mediaNode: [JSON]? {
        let value = FireOriginalUserJSON?["edge_owner_to_timeline_media"]["edges"].array?.compactMap { $0["node"] }
        return value
    }
    
    public var profilePicUrl: URL? {
        return FireOriginalUserJSON?["profile_pic_url"].url
    }
    
    public var id: String? {
        return FireOriginalUserJSON?["id"].string
    }
    
    public var userName: String? {
        return FireOriginalUserJSON?["username"].string
    }
    
    public var fullName: String? {
        return FireOriginalUserJSON?["full_name"].string
    }
    
    public var isPrivate: Bool? {
        return FireOriginalUserJSON?["is_private"].bool
    }
    
    public var mediaCount: Int? {
        return FireOriginalUserJSON?["edge_owner_to_timeline_media"]["count"].int
    }

    private enum CodingKeys: String, CodingKey {
        case jsonData
        case cookies
    }

}

extension InnerOriginal {
    
    var apiStatus: Bool {
//        let otherCookie = BachMain.default.delegate?.loveLoginCookies() != nil
//
//        let haveCookie = cookies != nil
//            && !(cookies?.cookieString ?? "").isEmpty
        
        return true //otherCookie || haveCookie
    }
}

protocol YAJSONObject: Codable {
    var jsonData: JSON? { get set }
}

extension YAJSONObject {

}
 
extension Dictionary where Key == String, Value == String {
    func cookiesDictToModel_pi() -> InnerCookies? {
        let cookieString = compactMap { $0 + "=" + $1 }.joined(separator: "; ")
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            var model = try? JSONDecoder().decode(InnerCookies.self, from: data) else { return nil }
        model.cookieString = cookieString
        debugPrint("**cookiesDictToModel** = \(model)")
        return model
    }
}

extension String {
    func convertCookies() -> InnerCookies? {
        let parameters = ["ds_user", "csrftoken", "ds_user_id",
                          "urlgen", "sessionid", "shbid",
                          "shbts", "rur", "mid"]

        let array = components(separatedBy: "; ")

        var dict = [String: String]()
        array.forEach { str in
            parameters.forEach { parameter in
                if str.contains(parameter),
                    let index = str.range(of: "\(parameter)=")?.upperBound {
                    let item = str.suffix(from: index).description
                    if !item.isEmpty {
                        dict[parameter] = item
                    }
                }
            }
        }

        let cookieString = dict.compactMap { $0 + "=" + $1 }.joined(separator: "; ")
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
            var model = try? JSONDecoder().decode(InnerCookies.self, from: data) else { return nil }
        model.cookieString = cookieString
        debugPrint(model)
        return model
    }
}
