//
//  SWSettingView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit

let AppName: String = "Followers' Widget Pro"
let purchaseUrl = ""
let TermsofuseURLStr = "http://jazzy-boat.surge.sh/Terms_of_use.htm"
let PrivacyPolicyURLStr = "http://jazzy-boat.surge.sh/Privacy_Agreement.htm"

let feedbackEmail: String = "getwidgetprocreate@yahoo.com"
let AppAppStoreID: String = ""


class SWSettingView: UIView {
    var upVC: UIViewController?
    
    let topTitleLabel = UILabel()
    let feedbackBgView = UIView()
    let privacyBgView = UIView()
    let termBgView = UIView()
    let logoutBgView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SWSettingView {
    func setupView() {
        topTitleLabel.textAlignment = .center
        topTitleLabel.textColor = UIColor.black
        topTitleLabel.text = "Setting"
        topTitleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(100)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
        }
        
        setupFeedback()
        setupPrivacy()
        setupTermsofuse()
        setuplogoutBgView()
    }
}

extension SWSettingView {
    func setupFeedback() {
        // feedback
        
        feedbackBgView.backgroundColor = UIColor(hexString: "#F0F0F0")
        feedbackBgView.layer.cornerRadius = 24
        feedbackBgView.layer.masksToBounds = true
        addSubview(feedbackBgView)
        feedbackBgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(48)
        }
        
        let feedbackBtn = UIButton(type: .custom)
        feedbackBgView.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        let feedbackLabel = UILabel()
        feedbackLabel.text = "Feedback"
        feedbackLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        feedbackLabel.textColor = UIColor(hexString: "#000000")
        feedbackBgView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        let arrow = UIImageView()
        arrow.image = UIImage(named: "setting_next_ic")
        arrow.contentMode = .center
        feedbackBgView.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(20)
        }
        
    }
    
    func setupPrivacy() {
        // Privacy
        
        privacyBgView.backgroundColor = UIColor(hexString: "#F0F0F0")
        privacyBgView.layer.cornerRadius = 24
        privacyBgView.layer.masksToBounds = true
        
        addSubview(privacyBgView)
        privacyBgView.snp.makeConstraints {
            $0.top.equalTo(feedbackBgView.snp.bottom).offset(25)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(48)
        }
        
        let privacyBtn = UIButton(type: .custom)
        privacyBgView.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        privacyBtn.addTarget(self, action: #selector(provateBtnClick(sender:)), for: .touchUpInside)
        let privacyLabel = UILabel()
        privacyLabel.text = "Privacy"
        privacyLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        privacyLabel.textColor = UIColor(hexString: "#000000")
        privacyBgView.addSubview(privacyLabel)
        privacyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        
        let arrow = UIImageView()
        arrow.image = UIImage(named: "setting_next_ic")
        arrow.contentMode = .center
        privacyBgView.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(20)
        }
        
    }
    
    func setupTermsofuse() {
        // Termsofuse
        
        termBgView.backgroundColor = UIColor(hexString: "#F0F0F0")
        termBgView.layer.cornerRadius = 24
        termBgView.layer.masksToBounds = true
        
        addSubview(termBgView)
        termBgView.snp.makeConstraints {
            $0.top.equalTo(privacyBgView.snp.bottom).offset(25)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(48)
        }
        
        let termBtn = UIButton(type: .custom)
        termBgView.addSubview(termBtn)
        termBtn.setBackgroundImage(UIImage(named: "setting_bg_ic"), for: .normal)
        termBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        termBtn.addTarget(self, action: #selector(termsofuseBtnClick(sender:)), for: .touchUpInside)
        let termLabel = UILabel()
        termLabel.text = "Terms of use"
        termLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        termLabel.textColor = UIColor(hexString: "#000000")
        termBgView.addSubview(termLabel)
        termLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        let arrow = UIImageView()
        arrow.image = UIImage(named: "setting_next_ic")
        arrow.contentMode = .center
        termBgView.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(20)
        }
    }
    
    func setuplogoutBgView() {
        // Termsofuse
        
        logoutBgView.backgroundColor = UIColor(hexString: "#F0F0F0")
        logoutBgView.layer.cornerRadius = 24
        logoutBgView.layer.masksToBounds = true
        
        addSubview(logoutBgView)
        logoutBgView.snp.makeConstraints {
            $0.top.equalTo(termBgView.snp.bottom).offset(25)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(48)
        }
        
        let logoutBtn = UIButton(type: .custom)
        logoutBgView.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnBtnClick(sender:)), for: .touchUpInside)
        let logoutLabel = UILabel()
        logoutLabel.text = "Log out"
        logoutLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        logoutLabel.textColor = UIColor(hexString: "#000000")
        logoutBgView.addSubview(logoutLabel)
        logoutLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        let arrow = UIImageView()
        arrow.image = UIImage(named: "setting_next_ic")
        arrow.contentMode = .center
        logoutBgView.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(20)
        }
    }
    
}


extension SWSettingView {
     
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    @objc func provateBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    @objc func termsofuseBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    @objc func logoutBtnBtnClick(sender: UIButton) {
        
    }
    
    
    
}



extension SWSettingView: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
           controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion ?? "1.0")", isHTML: false)
           
           //打开界面
        self.upVC?.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}


extension UIDevice {
  
   ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
   var modelName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
      
       let machineMirror = Mirror(reflecting: systemInfo.machine)
       let identifier = machineMirror.children.reduce("") { identifier, element in
           guard let value = element.value as? Int8, value != 0 else {
               return identifier
           }
           return identifier + String(UnicodeScalar(UInt8(value)))
       }
      
       switch identifier {
           case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iphone 4"
           case "iPhone4,1":                               return "iPhone 4s"
           case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
           case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
           case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
           case "iPhone7,2":                               return "iPhone 6"
           case "iPhone7,1":                               return "iPhone 6 Plus"
           case "iPhone8,1":                               return "iPhone 6s"
           case "iPhone8,2":                               return "iPhone 6s Plus"
           case "iPhone8,4":                               return "iPhone SE"
           case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
           case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
           case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
           case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
           case "iPhone10,3", "iPhone10,6":                return "iPhone X"
           case "iPhone11,2":                              return "iPhone XS"
           case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
           case "iPhone11,8":                              return "iPhone XR"
           case "iPhone12,1":                              return "iPhone 11"
           case "iPhone12,3":                              return "iPhone 11 Pro"
           case "iPhone12,5":                              return "iPhone 11 Pro Max"
           case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
           case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
           case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
           case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
           case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
           case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
           case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
           case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
           case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
           case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
           case "AppleTV5,3":                              return "Apple TV"
           case "i386", "x86_64":                          return "Simulator"
           default:                                        return identifier
       }
   }
}


