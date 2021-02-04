//
//  SWymMainVC.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit
import SnapKit



class SWymMainVC: UIViewController {

    let contentBgView: UIView = UIView()
    let bottomBgView: UIView = UIView()
    
    var bottomBtns: [UIButton] = []
    let widgetBtn = UIButton(type: .custom)
    let guideBtn = UIButton(type: .custom)
    let storeBtn = UIButton(type: .custom)
    let settingBtn = UIButton(type: .custom)
    
    var contentViews: [UIView] = []
    let widgetView = SWWidgetView()
    let settingView = SWSettingView()
    let storeView = SWStoreView()
    let guideView = SWGuideView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#F9F9F7")
        // he /*
        HightLigtingHelper.default.delegate = self
        // he */
        initDatabase()
        setupView()
        setupWidgetView()
        setupSettingView()
        setupStoreView()
        setupGuideView()
        
        setupBottomBtns()
        
        bottomBtnClick(sender: widgetBtn)
        
    }
    
    func initDatabase() {
        InnerDBManager.default.prepareCommentUserListDatabase()
        
        InnerUserManager.default.loadCurrentUserLoginModelFromDB() {[weak self] success in
            guard let `self` = self else {return}
            HUD.hide()
            if InnerUserManager.default.currentUserLoginModel == nil || InnerUserManager.default.currentUserInfo == nil {
                DispatchQueue.main.async {
                    // 没有当前用户数据 展示登陆按钮
                    self.widgetView.showViewStatus(hasUser: false)
                }
            } else {
                // begin fetch data
                self.widgetView.showViewStatus(hasUser: true)
                //
            }
        }
        
    }
    
}


extension SWymMainVC {
    func setupView() {
        
        
        contentBgView.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.right.equalTo(0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-74)
        }
        
        bottomBgView.layer.masksToBounds = true
        bottomBgView.layer.cornerRadius = 30
        bottomBgView.backgroundColor = UIColor(hexString: "#D7EF90")
        view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-14)
        }
    }
}

extension SWymMainVC {
    func setupBottomBtns() {
        
        bottomBtns.append(widgetBtn)
        bottomBtns.append(guideBtn)
        bottomBtns.append(storeBtn)
        bottomBtns.append(settingBtn)
        
        
        let btnWidth: CGFloat = (UIScreen.width - (20 * 2) - 2) / 4
        
        widgetBtn.setImage(UIImage(named: "temeplate_ic_n"), for: .normal)
        widgetBtn.setImage(UIImage(named: "temeplate_ic_s"), for: .selected)
        bottomBgView.addSubview(widgetBtn)
        widgetBtn.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(40)
        }
        widgetBtn.addTarget(self, action: #selector(bottomBtnClick(sender:)), for: .touchUpInside)
        
        guideBtn.setImage(UIImage(named: "text_ic_n"), for: .normal)
        guideBtn.setImage(UIImage(named: "text_ic_s"), for: .selected)
        bottomBgView.addSubview(guideBtn)
        guideBtn.snp.makeConstraints {
            $0.left.equalTo(widgetBtn.snp.right)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(40)
        }
        guideBtn.addTarget(self, action: #selector(bottomBtnClick(sender:)), for: .touchUpInside)
        
        storeBtn.setImage(UIImage(named: "store_ic_n"), for: .normal)
        storeBtn.setImage(UIImage(named: "store_ic_s"), for: .selected)
        bottomBgView.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.left.equalTo(guideBtn.snp.right)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(40)
        }
        storeBtn.addTarget(self, action: #selector(bottomBtnClick(sender:)), for: .touchUpInside)
        
        settingBtn.setImage(UIImage(named: "setting_ic_n"), for: .normal)
        settingBtn.setImage(UIImage(named: "setting_ic_s"), for: .selected)
        bottomBgView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(40)
        }
        settingBtn.addTarget(self, action: #selector(bottomBtnClick(sender:)), for: .touchUpInside)
        
        
        
    }
    
    
}

extension SWymMainVC {
    func setupWidgetView() {
        
        contentViews.append(widgetView)
        
        widgetView.upVC = self
        contentBgView.addSubview(widgetView)
        widgetView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func setupSettingView() {
        contentViews.append(settingView)
        
        settingView.upVC = self
        contentBgView.addSubview(settingView)
        settingView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func setupStoreView() {
        contentViews.append(storeView)
        
        storeView.upVC = self
        contentBgView.addSubview(storeView)
        storeView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func setupGuideView() {
        contentViews.append(guideView)
        guideView.upVC = self
        contentBgView.addSubview(guideView)
        guideView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension SWymMainVC {
    @objc func bottomBtnClick(sender: UIButton) {
        for btn in bottomBtns {
            if btn == sender {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
            
        }
        if sender == widgetBtn {
            showContentView(targetView: widgetView)
        } else if sender == guideBtn {
            showContentView(targetView: guideView)
        } else if sender == storeBtn {
            showContentView(targetView: storeView)
        } else if sender == settingBtn {
            showContentView(targetView: settingView)
        }
    }
     
    func showContentView(targetView: UIView) {
        for subview in contentViews {
            if subview == targetView {
                subview.isHidden = false
            } else {
                subview.isHidden = true
            }
        }
    }
}

extension SWymMainVC: HightLigtingHelperDelegate {

    func open(isO: Bool) {
        debugPrint("isOpen = \(isO)")
    }
    
    func open() -> UIButton? {
        let coreButton = UIButton()
        coreButton.setImage(UIImage(named: "get_li\("ke_btn")"), for: .normal)
        coreButton.addTarget(self, action: #selector(coreButtonClick(button:)), for: .touchUpInside)
        self.view.addSubview(coreButton)
        coreButton.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(68)
            make.bottom.equalTo(bottomBgView.snp.top).offset(-24)
            make.centerX.equalTo(self.view)
        }

        return coreButton
    }
    
    @objc func coreButtonClick(button: UIButton) {
        HightLigtingHelper.default.present()
    }
    
    func preparePopupKKAd(placeId: String?, placeName: String?) {
        
    }

    
    func showAd(type: Int, userId: String?, source: String?, complete: @escaping ((Bool, Bool, Bool) -> Void)) {
        var adType:String = ""
        switch type {
        case 0:
            adType = "KKAd"
        case 1:
            adType = "interstitial Ad"
        case 2:
            adType = "reward Video Ad"
        default:
            break
        }
        
        
    }
}

