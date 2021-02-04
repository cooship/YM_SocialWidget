//
//  WILoginHelper.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/3.
//

import UIKit

class WILoginHelper: NSObject {
    static let `default` = WILoginHelper()
    var webLoginVC: WIWebInstaLoginVC?
    
    func showLoginPage(showClose: Bool, targetViewController: UIViewController, completion: @escaping ((Bool, String?)->Void)) {
        
        let webVC = WIWebInstaLoginVC()
        webLoginVC = webVC
        webVC.loginComplete = {
            [weak self] success, cookiesDict in
            guard let `self` = self else {return}
            if success {
                let userModel = InnerUserLoginModel()
                InnerUserManager.default.currentUserLoginModel = userModel
                
                userModel.loginType = "WEB"
                userModel.cookieDict = cookiesDict
                 
            } else {
                
            }
        }
        
        webVC.getUserInfoComplete = {
            [weak self] success, errorMessage, userDetailsDict in
            guard let `self` = self else {return}
            if success {
                let profileInfo = InnerUserProfileInfo()
                profileInfo.username = userDetailsDict["username"] as? String ?? ""
                profileInfo.avatarUrl = userDetailsDict["profile_pic_url"] as? String ?? ""
                profileInfo.userid = userDetailsDict["pk"] as? Int ?? 0
                
                InnerUserManager.default.currentUserLoginModel?.userProfileInfo = profileInfo
                
                let autenKey = "hasAuthenticationInThisDevice_\(profileInfo.userid ?? 0)"
                let isAuthend = UserDefaults.standard.bool(forKey: autenKey)
                if isAuthend {
                    
                    self.webLoginVC?.dismiss(animated: true, completion: nil)
                    completion(true, nil)
                }
                 
            }
        }
        webVC.authCompleteHandler = { [weak self] in
            debugPrint("auth success call back")
            guard let `self` = self else { return }
             
            let autenKey = "hasAuthenticationInThisDevice_\(InnerUserManager.default.currentUserLoginModel?.userProfileInfo.userid ?? 0)"
            UserDefaults.standard.set(true, forKey: autenKey)
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                self.webLoginVC?.dismiss(animated: true, completion: nil)
                completion(true, nil)
            }
        }
        
        let targetViewController = targetViewController.visibleVC ?? targetViewController
        guard let visibleName = targetViewController.visibleVC?.className,
        visibleName != "IGWebLoginViewController",
        !visibleName.contains("Alert")  else { return }
        
        webVC.modalPresentationStyle = .fullScreen
        targetViewController.present(webVC)
        
    }
    
}
