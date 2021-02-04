//
//  Request_Inner.swift
//  YAO_Core
//
//  Created by JOJO on 2020/7/2.
//  Copyright © 2020 JOJO. All rights reserved.
//

import UIKit
import Moya
import MoyaSugar
import SwiftyJSON
import DeviceKit
 

// MARK: - INS 接口的其他请求

extension Request {
    enum FireError: Error {
//        case accessFailure
        case verificationFailed
        case networkFailure
        case apiLogout

        var errorDescription: String {
            switch self {
            case .verificationFailed:
                return "This account is invalid, please try again"
            case .networkFailure:
                return "Internal Error, Please try again later"
            case .apiLogout:
                return "Login Required"
            }
        }
    }
    
     
    static func fireDetail(name: String,
                           cookies: InnerCookies? = nil,
                           complection: @escaping ((Result<InnerOriginal, FireError>) -> Void)) {
        let target = InnerAPI.profile(name: name, cookies: cookies)

        getStringResult(target: target, success: { result, statusCode in
            guard let value = result else {
                if statusCode == 404 {
                    complection(.failure(.verificationFailed))
                } else {
                    complection(.failure(.networkFailure))
                }
                return
            }
            let pattern = "(?<=graphql\":)(.*)(?=,\"toast)"
            let regex = try? NSRegularExpression(pattern: pattern,
                                                 options: [])
            let matches = regex?.matches(in: value, options: [], range: NSRange(location: 0, length: value.count))
            guard let nsRange = matches?.first?.range,
                let range = Range(nsRange, in: value) else {
                complection(.failure(.verificationFailed))
                return
            }
            let jsonText = String(value[range])

            if let data = jsonText.data(using: .utf8, allowLossyConversion: false) {
                do {
                    var model = try JSONDecoder().decode(InnerOriginal.self, from: data)
                    model.jsonData = try JSON(data: data)
                    complection(.success(model))
                } catch {
                    complection(.failure(.verificationFailed))
                }
            }
        }, failure: { _ in
            complection(.failure(.networkFailure))
        })
    }

    static func getStringResult(target: InnerAPI,
                                success: ((String?, Int) -> Void)?,
                                failure: ((MoyaError?) -> Void)? = nil) {
        let provider = InnerProvider
        provider
            .request(target) { result in
                switch result {
                case let .success(response):
                    switch response.statusCode {
                    case 200:
                        let string = try? response.mapString()
                        success?(string, response.statusCode)
                    default:
                        success?(nil, response.statusCode)
                    }
                case let .failure(error):
                    failure?(error)
                }
        }
    }
}

extension Request {
    
}




public enum InnerAPI {
    case getUserInfo(userId: String)
    case profile(name: String, cookies: InnerCookies?)
    
    
}

extension InnerAPI: SugarTargetType {
    
    public var baseURL: URL {
        switch self {
        case .profile:
            return URL(string: "https://www.in\("stag")ram.com")!
        default:
            return URL(string: "https://i.in\("stag")ram.com")!
        }
    }

    public var route: Route {
        switch self {
        case let .getUserInfo(userId):
            return .get("/api/v1/users/\(userId)/info/")
        case let .profile(name, _):
            return
                .get("/\(name)")

        
        }
    }

    public var parameters: Parameters? {
        let fireCookie: InnerCookies? = InnerUserManager.default.currentUserInfo?.cookies
        let sha256KEY = "31daaa1bd12d53b039e0e21fe4214e6bb74ab2cd93854b48005bb4d1281ed405"
        let uuid = UUID().uuidString

        switch self {
         
        default:
            return nil
        }
    }

    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {

        switch self {
        case .profile(_, let cookies):
            return customCookies(cookies)
        default:
            return customCookies()
        }
    }
    
    func customCookies(_ cookie: InnerCookies? = nil) -> [String: String]? {
        
        let fireCookie = cookie ?? InnerUserManager.default.currentUserInfo?.cookies
        
        let osVersion = Device.current.systemVersion?
        .components(separatedBy: ".").joined(separator: "_") ?? "13_5"
        var userAgent = "In\("stag")ram 121.0.0.29.119(iPhone 7,1; iOS 12_2; en_US; en; scale=2.61; 1080x1920) AppleWebKit/420+"

        if UIApplication.shared.inferredEnvironment != .debug {
            let deviceIdentifier = Device.identifier

            userAgent =
                "In\("stag")ram 121.0.0.29.119(\(deviceIdentifier)"
                    + "; iOS \(osVersion); \(Locale.current.identifier)"
                    + "; \(Locale.preferredLanguages.first ?? "en")"
                    + "; scale=\(UIScreen.main.nativeScale)"
                    + "; \(UIScreen.main.nativeBounds.width)x\(UIScreen.main.nativeBounds.height)"
                    + ") AppleWebKit/420+"
        }

        return [
            "Cookie": fireCookie?.cookieString ?? "",
            "User-Agent": userAgent,
            "ccode": "US",
            "csrftoken": fireCookie?.csrftoken ?? "",
            "ds_user": fireCookie?.dsUser ?? "",
            "ds_user_id": fireCookie?.dsUserId ?? "",
            "sessionid": fireCookie?.sessionid ?? "",
            "mid": fireCookie?.mid ?? ""
        ]
    }
}


