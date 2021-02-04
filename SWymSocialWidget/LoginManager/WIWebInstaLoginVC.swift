//
//  WIWebInstaLoginVC.swift
//  SWymSocialWidget
//
//  Created by xx on 2021/2/3.
//

import UIKit
import WebKit
import ZKProgressHUD
import Alertift


class WIWebInstaLoginVC: UIViewController {
    // pub
    var loginComplete: ((Bool, [String: String])->Void)?
    var getUserInfoComplete: ((Bool, String, [AnyHashable : Any])->Void)?
    var closeLoginPageHandler: (()->Void)?
    var authCompleteHandler: (()->Void)?
    // pri
    let webView: WKWebView = WKWebView(frame: .zero)
    var loginCookieDict: [String: String]?
    var userId: String? = ""
    var beginRequestUserInfo: Bool = false
    var isClose: Bool = false
    
    var closeBtn: UIButton = UIButton(type: .custom)
    let bottomBgView = UIView()
    let bottomTitleLabel = UILabel()
    //
    
    var isShowCloseBtn: Bool = true {
        didSet {
            bottomBgView.isHidden = !isShowCloseBtn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        deleteCookie {
            [weak self] in
            guard let `self` = self else {return}
            if let url = URL.init(string:"https://www.instagram.com/accounts/login/") {
                self.webView.load(URLRequest.init(url: url))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isClose = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies ?? [] {
            storage.deleteCookie(cookie)
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
    }
    
}

extension WIWebInstaLoginVC {
    func setupUI() {
        bottomBgView.isHidden = !isShowCloseBtn
        closeBtn.setImage(UIImage(named: "delete_button"), for: .normal)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(40)
        }
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        
        
        bottomBgView.backgroundColor = UIColor.black
        view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        bottomBgView.addSubview(bottomTitleLabel)
        bottomTitleLabel.textAlignment = .center
        bottomTitleLabel.text = "The app never sees or stores your Instagram password."
        bottomTitleLabel.font = UIFont(name: "Avenir-Medium", size: 14)
        bottomTitleLabel.textColor = .white
        bottomTitleLabel.numberOfLines = 2
        bottomTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
        
    }
    
    @objc func closeBtnClick(sender: UIButton) {
        closeLoginPage()
    }
    
}

extension WIWebInstaLoginVC {
    func setupView() {
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.right.left.equalToSuperview()
        }
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        
    }
    
}
 
extension WIWebInstaLoginVC {
    func deleteCookie(completion: @escaping (()->Void)) {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName.contains("instagram") || record.displayName.contains("facebook") {
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {
                            
                    }
                }
            }
            completion()
        }
    }
    
    func clearCookie() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        URLCache.shared.removeAllCachedResponses()
        
    }
    
    func cancelAuthorization() {
        deleteCookie {
            [weak self] in
            guard let `self` = self else {return}
            self.loginCookieDict = nil
            if let url = URL(string: "https://www.instagram.com/accounts/login/") {
                self.webView.load(URLRequest.init(url: url))
            }
            
        }
    }
    
    func resetCurrentLoginInsCookie(cookieDict: [String: String]) {
        clearCookie()
        
        func setCookie(version: String, path: String, name: String, value: String, domain: String) {
            var fromappDict: [HTTPCookiePropertyKey: Any] = [:]
            fromappDict[HTTPCookiePropertyKey.version] = version
            fromappDict[HTTPCookiePropertyKey.path] = path
            fromappDict[HTTPCookiePropertyKey.name] = name
            fromappDict[HTTPCookiePropertyKey.value] = value
            fromappDict[HTTPCookiePropertyKey.domain] = domain
            if let cookie = HTTPCookie.init(properties: fromappDict) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
        setCookie(version: "0", path: "/", name: "csrftoken", value: cookieDict["csrftoken"] ?? "", domain: ".instagram.com")
        setCookie(version: "0", path: "/", name: "ds_user_id", value: userId ?? "", domain: ".instagram.com")
        setCookie(version: "0", path: "/", name: "rur", value: "PRN", domain: ".instagram.com")
        setCookie(version: "0", path: "/", name: "urlgen", value: "\"{\"104.245.13.89\": 21859}:1hOiip:z6gd0Gij256B5LWQKlerXSsj6zM\"", domain: ".instagram.com")
        setCookie(version: "0", path: "/", name: "ds_user", value: cookieDict["ds_user"] ?? "", domain: ".instagram.com")
        setCookie(version: "0", path: "/", name: "sessionid", value: cookieDict["sessionid"] ?? "", domain: ".instagram.com")
        setCookie(version: "0", path: "/", name: "mid", value: cookieDict["mid"] ?? "", domain: ".instagram.com")
    }
    
    func parseNativeCookie(completion: @escaping (Bool)->Void) {
        var cookieDict: [String: String] = [:]
        let store = WKWebsiteDataStore.default()
        store.httpCookieStore.getAllCookies {[weak self] (cookies) in
            guard let `self` = self else {return}
            for cookie in cookies {
                cookieDict[cookie.name] = cookie.value
            }
            self.loginCookieDict = cookieDict
            if let _ = cookieDict["ds_user_id"] {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func requestUserInfoWithCookies(cookieDict: [String: String]) {
        beginRequestUserInfo = true
         
        var cookieDict_m: [String: String] = [:]
        for key in cookieDict.keys {
            let value = cookieDict[key]
            cookieDict_m[key] = value
        }
        loginComplete?(true, cookieDict_m)
        // HUD show
        ZKProgressHUD.show()
        
        userId = cookieDict["ds_user_id"]
        resetCurrentLoginInsCookie(cookieDict: cookieDict)
        IGLInsRequest.sharedInstance().getUserInfo(userId ?? "", token: cookieDict["csrftoken"] ?? "", user: cookieDict["ds_user"] ?? "", userId: userId ?? "", mid: cookieDict["mid"] ?? "", sessionId: cookieDict["sessionid"] ?? "") {[weak self] (success, errorMessage, userDetailsDic) in
            
            guard let `self` = self else {return}
            let authenKey = "hasAuthenticationInThisDevice_\(self.userId ?? "")"
            UserDefaults.standard.setValue(true, forKey: authenKey)
            
            self.getUserInfoComplete?(success, errorMessage, userDetailsDic)
            
            DispatchQueue.main.async {
                // HUD hidden
                ZKProgressHUD.dismiss()
                if success {
                    self.closeLoginPage()
                } else {
                    self.closeLoginPage()
                    ZKProgressHUD.showError(errorMessage)
                    
                }
            }
        }
    }
    
    func closeLoginPage() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                [weak self] in
                guard let `self` = self else {return}
                self.closeLoginPageHandler?()
            }
        }
    }
    
    func testWithLoop(loop: Bool, completion: @escaping (()->Void)) {
        if beginRequestUserInfo || isClose {
            return
        }
        parseNativeCookie {[weak self] (success) in
            guard let `self` = self else {return}
            if success {
                if self.beginRequestUserInfo == false {
                    if let loginCookieDict_m = self.loginCookieDict {
                        self.requestUserInfoWithCookies(cookieDict: loginCookieDict_m)
                    }
                }
                completion()
            } else {
                if loop {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.testWithLoop(loop: loop, completion: completion)
                    }
                }
            }
        }
    }
    
    func handleQuery(queryName: String, queryValue: String) {
        if queryName.contains("allow") {
            if queryValue.contains("Authorize") {
                finishAuthorization()
            } else if queryValue.contains("Cancel") {
                cancelAuthorization()
            }
        }
    }
    
    func finishAuthorization() {
        let authenKey = "hasAuthenticationInThisDevice_\(userId ?? "")"
        UserDefaults.standard.setValue(true, forKey: authenKey)
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.authCompleteHandler?()
            self.closeLoginPage()
        }
    }
    
    
    
    
}



extension WIWebInstaLoginVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.parseNativeCookie {[weak self] (isSuccess) in
            guard let `self` = self else {return}
            if isSuccess {
                if self.beginRequestUserInfo == false {
                    if let loginCookieDict_m = self.loginCookieDict {
                        self.requestUserInfoWithCookies(cookieDict: loginCookieDict_m)
                    }
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url?.scheme == "ios" {
            if navigationAction.request.url?.absoluteString == "ios://notUser"{
                decisionHandler(.cancel)
                cancelAuthorization()
            } else {
                var queryString = navigationAction.request.url?.query
                queryString = queryString?.replacingOccurrences(of: "+", with: "%20")
                let queryArray = NormalHelper.queryArray(fromQueryStrings: queryString ?? "")
                if queryArray.count == 1, let queryDictionary = queryArray[0] as? [String: String], let queryName = queryDictionary["name"], let queryValue = queryDictionary["value"] {
                    
                    handleQuery(queryName: queryName, queryValue: queryValue)
                    
                    if queryValue.contains("Cancel") {
                        decisionHandler(.allow)
                    } else {
                        decisionHandler(.cancel)
                    }
                } else {
                    decisionHandler(.allow)
                }
            }
        } else {
            var hasUserId = false
            
            if let loginCookieDict_m = self.loginCookieDict {
                for key in loginCookieDict_m.keys {
                    if key.contains("ds_user_id") {
                        hasUserId = true
                    }
                }
            }
            
            if navigationAction.request.url?.absoluteString.contains("detail.html") == true {
                decisionHandler(.allow)
            } else {
                if hasUserId {
                    if !beginRequestUserInfo, let loginCookieDict_m = loginCookieDict {
                        requestUserInfoWithCookies(cookieDict: loginCookieDict_m)
                    }
                    decisionHandler(.cancel)
                } else {
                    if navigationAction.request.url?.absoluteString == "https://www.instagram.com/" {
                        ZKProgressHUD.show()
                        testWithLoop(loop: true) {
                            
                        }
                    } else if navigationAction.request.url?.absoluteString == "https://www.instagram.com/accounts/login/" {
                        testWithLoop(loop: false) {
                            
                        }
                    } else if navigationAction.request.url?.absoluteString == "https://m.facebook.com/login" {
                        testWithLoop(loop: false) {
                            
                        }
                    } else {
                        testWithLoop(loop: true) {
                            
                        }
                    }
                    decisionHandler(.allow)
                }
            }
            
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.absoluteString == "https://www.instagram.com/accounts/login/" {
            ZKProgressHUD.dismiss()
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Alertift
            .alert(message: "Web login failed, use another way to continue.")
            .action(.cancel("OK"), handler: { _, _, _ in
                
            })
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
    }
        
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Alertift
            .alert(message: "Web login failed, use another way to continue.")
            .action(.cancel("OK"), handler: { _, _, _ in
                
            })
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
    }
}




