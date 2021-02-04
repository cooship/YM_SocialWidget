//
//  Request.swift
//  YAO_Core
//
//  Created by JOJO on 2020/7/3.
//  Copyright © 2020 JOJO. All rights reserved.
//

import UIKit
import Alamofire
import Alertift
import Foundation
import Moya
import MoyaSugar
import SwiftyJSON
import DeviceKit


class RequestProvider<Target: SugarTargetType>: MoyaSugarProvider<Target> {
    
}



enum GPErrorMessage: Error {
    case loginRequired
    case unknown
    case with(message: String)

    init(_ message: String) {
        switch message {
        case "login_required", "challenge_required":
            self = .loginRequired
        default:
            self = message.isEmpty ? .unknown : .with(message: message)
        }
    }
}

extension GPErrorMessage: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loginRequired:
            return NSLocalizedString("In\("stag")ram has recently added a 'captcha' to their app to confirm that you are a human and not a bot. To get past this, you'll have to share/l\("ike") a photo on the actual in\("stag")ram app, and before you share/l\("ike") it, it'll ask you to enter some letters to confirm that you're human. After you do that, you should be able to access all your 3rd party apps again.", comment: "")
        case .unknown:
            return NSLocalizedString("An unknown error occurred", comment: "")
        case let .with(message):
            return NSLocalizedString(message, comment: "")
        }
    }
}




class Request {
    
    static let InnerProvider = RequestProvider<InnerAPI>(plugins: [TimeoutPlugin()])

    struct Dispose {
        static let apiError: ((Error) -> Void) = { error in
            guard let apiError = error as? GPErrorMessage
                 else {
                    HUD.error(error.localizedDescription)
                    return
            }
            Alert.error(apiError.errorDescription, success: {
                switch apiError {
                
                default: break
                }
            })
        }
    }
 

    static func getResult<T>(_ type: T.Type,
                             target: InnerAPI,
                             success: ((T?) -> Void)?,
                             failure: ((Error) -> Void)? = Dispose.apiError)
        where T: Codable {
        let provider = InnerProvider

        provider.request(target) { result in
            // 隐藏hud
            switch result {
            case let .success(response):
                debugPrint(response)
                
                do {
                    let jsondata =  try JSON(data: response.data)
                    debugPrint("jsondata = \(jsondata)")
                    var model = try response.map(type)
                    if var json = model as? YAJSONObject {
                        json.jsonData = try JSON(data: response.data)
                        model = json as! T
                    }
                    success?(model)
                } catch {
                    failure?(error)
                }
                
                
            case let .failure(error):
                failure?(error)
            }
        }
    }
}
 

extension Request {
    @discardableResult
    static func networkReachable() -> Bool {
        let reachability = NetworkReachabilityManager()
        let status = reachability?.status
        let isRechable = status != .unknown && status != .notReachable
        if !isRechable {
            HUD.error("The Internet connection appears to be offline.")
        }
        return isRechable
    }

    class TimeoutPlugin: PluginType {
        init() {}

        func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
            var request = request
            request.timeoutInterval = 15
            return request
        }
    }
}

