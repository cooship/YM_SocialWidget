//
//  SWymEditVC.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import UIKit
import NoticeObserveKit


class SWymEditVC: UIViewController {

    private var pool = Notice.ObserverPool()
    
    let backBtn: UIButton = UIButton(type: .custom)
    let loginBtn: UIButton = UIButton(type: .custom)
    let userNameLabel: UILabel = UILabel(frame: .zero)
    
    let widgetContentView: UIView = UIView()
    let toolViewBgView: UIView = UIView()
    let bgSetBtn: UIButton = UIButton(type: .custom)
    let textSetBtn: UIButton = UIButton(type: .custom)
    
    let bgColorView: SWBgColorView = SWBgColorView()
    let textToolView: SWTextToolView = SWTextToolView()
    
    let widgetBtn: UIButton = UIButton(type: .custom)
    
    var widgetItem: SWWidgetItem
    
    let small_height: CGFloat = 155
    let middle_height: CGFloat = 155
    let large_height: CGFloat = 260
    
    var currentBgColor: String?
    var currentTextColor: String = "#FFFFFF"
    var currentTextFontName: String = "Avenir-Heavy"
    
    init(widgetItem: SWWidgetItem) {
        self.widgetItem = widgetItem
        self.currentTextColor = widgetItem.textColor ?? "#FFFFFF"
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#F1F1EF")
        addObserver()
        setupView()
        setupContentView()
        setupToolContentView()
    }
    

    func addObserver() {
        // 登陆成功后 刷新页面
        NotificationCenter.default.nok.observe(name: .fetchUserDetailInfoSuccess) {[weak self] _ in
            guard let `self` = self else {return}
            self.updateContentStatus()
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .logoutCurrentUserAccount) {[weak self] _ in
            guard let `self` = self else {return}
            self.updateContentStatus()
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .userProfileImgComplete) {[weak self] _ in
            guard let `self` = self else {return}
            self.updateContentStatus()
        }
        .invalidated(by: pool)
        
    }

    
    
}

extension SWymEditVC {
    func setupView() {
        // back btn
        backBtn.setImage(UIImage(named: "edit_back_ic"), for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        // loginBtn
        loginBtn.setTitle("+ Add account", for: .normal)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.right.equalTo(-18)
            $0.centerY.equalTo(backBtn)
            $0.height.equalTo(40)
            $0.width.greaterThanOrEqualTo(120)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        
        // user name label
        
        userNameLabel.textAlignment = .right
        userNameLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        userNameLabel.textColor = UIColor.black
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalTo(backBtn)
            $0.height.equalTo(40)
            $0.width.greaterThanOrEqualTo(80)
        }
        
        updateContentStatus()
        
    }
    
    func updateContentStatus() {
        //TODO: 通知后调用
        updateUserName()
        self.updateWidtetContent()
         
    }
    
    func updateUserName() {
        if InnerUserManager.default.currentUserInfo != nil {
            userNameLabel.isHidden = false
            loginBtn.isHidden = true
        } else {
            userNameLabel.isHidden = true
            loginBtn.isHidden = false
        }
        userNameLabel.text = "@\(InnerUserManager.default.currentUserInfo?.userName ?? "")"
        
    }
    
    func updateWidtetContent() {
        //TODO: set widget item preview
        widgetContentView.removeSubviews()
        
        let sizeType = SizeStyle.init(rawValue: widgetItem.widthSize ?? "small") ?? .small
        let widgetPreviewConfig = processWidgetConfig()
        
        var previewHeight: CGFloat = small_height
        
        if sizeType == .large {
            previewHeight = large_height
        }
        let widgetPreview = StuffWidgetHelper.default.widgetPreivew(viewHeight: previewHeight, size: sizeType, widgetConfig: widgetPreviewConfig)
        widgetPreview.frame = CGRect(x: 0, y: 0, width: widgetPreview.width, height: widgetPreview.height)
        widgetPreview.isUserInteractionEnabled = false
        widgetPreview.layer.cornerRadius = 20
        widgetPreview.layer.masksToBounds = true
        widgetContentView.addSubview(widgetPreview)
        widgetPreview.center = CGPoint(x: UIScreen.width / 2, y: 260 / 2)
        
    }
    
    func processWidgetConfig() -> WidgetConfig {
        //TODO: Widget Config
        var userName = "Widget"
        var fullName = "widget"
        var fanCountString = "10K"
        var profileIconData: Data? = UIImage(named: "ins_muban_6")!.jpegData(compressionQuality: 0.8)
        let stickerImageName: String? = widgetItem.stickername
        var bgImageColor = ThemeColor.init(bgImgName: widgetItem.bgImgName, normalColor: nil, gradientColor: nil)
        let layoutType: LayoutType = LayoutType.init(rawValue: widgetItem.layoutType?.int ?? 1) ?? .layout1
        
        let sizeType = SizeStyle.init(rawValue: widgetItem.widthSize ?? "small") ?? .small
        
        if let bgColorName = currentBgColor {
            bgImageColor = ThemeColor.init(bgImgName: nil, normalColor: ThemeColor.p_Color.init(color: bgColorName, alpha: 1), gradientColor: nil)
        }
        
        
        let textFont = currentTextFontName
        let textColor = ThemeColor.p_Color.init(color: currentTextColor, alpha: 1)
        
        if InnerUserManager.default.currentUserInfo != nil {
            userName = InnerUserManager.default.currentUserInfo?.userName ?? "0"
            fullName = InnerUserManager.default.currentUserInfo?.fullName ?? "0"
            fanCountString = InnerUserManager.default.currentUserInfo?.foreverCount?.k() ?? "0"
            profileIconData = InnerUserManager.default.currentIconImageData
        }
        
        let widgetPreviewConfig: WidgetConfig = WidgetConfig.init(widgetIdName: "\(layoutType)", bgColor: bgImageColor, layoutType: layoutType, sizeType: sizeType, userProfileImgData: profileIconData, userName: userName, fullName: fullName, fanCount: fanCountString, textFont: textFont, textColor: textColor, stickerImgName: stickerImageName)
        return widgetPreviewConfig
    }
    
    func setupContentView() {
        
        view.addSubview(widgetContentView)
        widgetContentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.height.equalTo(260)
        }
        widgetContentView.backgroundColor = .clear
        
        // toolViewBgView
        view.addSubview(toolViewBgView)
        toolViewBgView.backgroundColor = .clear
        toolViewBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(widgetContentView.snp.bottom).offset(16)
            $0.height.equalTo(120)
        }
        
        // color btn
        bgSetBtn.setImage(UIImage(named: "edit_background_ic"), for: .normal)
        view.addSubview(bgSetBtn)
        bgSetBtn.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.right.equalTo(view.snp.centerX).offset(-10)
            $0.top.equalTo(toolViewBgView.snp.bottom).offset(30)
        }
        bgSetBtn.addTarget(self, action: #selector(bgSetBtnClick(sender:)), for: .touchUpInside)
        
        // text set btn
        textSetBtn.setImage(UIImage(named: "edit_font_ic"), for: .normal)
        view.addSubview(textSetBtn)
        textSetBtn.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.left.equalTo(view.snp.centerX).offset(10)
            $0.top.equalTo(toolViewBgView.snp.bottom).offset(30)
        }
        textSetBtn.addTarget(self, action: #selector(textSetBtnClick(sender:)), for: .touchUpInside)
        
        // widgetBtn
        widgetBtn.setTitle("Get widget", for: .normal)
        widgetBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        widgetBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        widgetBtn.setBackgroundColor(UIColor(hexString: "#131313") ?? .white, for: .normal)
        widgetBtn.layer.cornerRadius = 24
        widgetBtn.layer.masksToBounds = true
        view.addSubview(widgetBtn)
        widgetBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
            $0.width.equalTo(200)
            $0.height.equalTo(48)
        }
        widgetBtn.addTarget(self, action: #selector(widgetBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    func setupToolContentView() {
        // bgColorView
        bgColorView.didSelectColorBlock = {
             item in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.currentBgColor = item
                self.updateWidtetContent()
            }
        }
        bgColorView.isHidden = true
        toolViewBgView.addSubview(bgColorView)
        bgColorView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        // textToolView
        textToolView.didSelectColorBlock = {
             item in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.currentTextColor = item
                self.updateWidtetContent()
            }
        }
        textToolView.didSelectFontBlock = {
             item in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.currentTextFontName = item
                self.updateWidtetContent()
            }
            
        }
        textToolView.isHidden = true
        toolViewBgView.addSubview(textToolView)
        textToolView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension SWymEditVC {
    func showLoginVC() {
        WILoginHelper.default.showLoginPage(showClose: true, targetViewController: self) { (success, errorMsg) in
            if success {
                debugPrint("\(self.className)")
                // save userlogin info to db
                InnerUserManager.default.saveAndUpdateCurrentUserInfoToDB()
                //
                InnerUserManager.default.loadCurrentUserDetailInfo {[weak self] (success) in
                    guard let `self` = self else {return}
                    HUD.hide()
                    if success {
                        self.updateContentStatus()
                    } else {
                        HUD.error("fetch user info error!")
                    }
                }
            }
        }
    }
}

extension SWymEditVC {
    
    
}


extension SWymEditVC {
    @objc func backBtnClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true, nil)
    }
    @objc func bgSetBtnClick(sender: UIButton) {
        bgColorView.isHidden = false
        textToolView.isHidden = true
        
    }
    @objc func textSetBtnClick(sender: UIButton) {
        bgColorView.isHidden = true
        textToolView.isHidden = false
    }
    @objc func widgetBtnClick(sender: UIButton) {
        
        if InnerUserManager.default.currentUserInfo == nil {
            showLoginVC()
            return
        }
        
        var widgetPackge = StuffWidgetHelper.default.fetchCurrentConfig(groupId: WidgetGroupType.profile.rawValue)
        let config = processWidgetConfig()
        if widgetItem.widthSize == "small" {
            widgetPackge.small = config
        } else if widgetItem.widthSize == "medium" {
            widgetPackge.middle = config
        } else if widgetItem.widthSize == "large" {
            widgetPackge.large = config
        }
        
        StuffWidgetHelper.default.saveThemeConfigure(themeConfig: widgetPackge)
        
        showAlert(title: "Successfully", message: "", buttonTitles: ["OK"], highlightedButtonIndex: 0) { (index) in
            
        }
        
    }
    @objc func loginBtnClick(sender: UIButton) {
        showLoginVC()
    }
    
}








