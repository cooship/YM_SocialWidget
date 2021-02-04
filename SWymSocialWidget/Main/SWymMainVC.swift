//
//  SWymMainVC.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit
import SnapKit
import NoticeObserveKit


class SWymMainVC: UIViewController {

    private var pool = Notice.ObserverPool()
    
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
        addObserver()
        initDatabase()
        setupView()
        setupWidgetView()
        setupSettingView()
        setupStoreView()
        setupGuideView()
        
        setupBottomBtns()
        
        bottomBtnClick(sender: widgetBtn)
        
    }
    
    func addObserver() {
        // 登陆成功后 刷新页面
        NotificationCenter.default.nok.observe(name: .fetchUserDetailInfoSuccess) {[weak self] _ in
            guard let `self` = self else {return}
            self.updateWidtetViewStatus()
        }
        .invalidated(by: pool)
        
    }
    
    func updateWidtetViewStatus() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
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
    
    func initDatabase() {
        InnerDBManager.default.prepareCommentUserListDatabase()
        
        InnerUserManager.default.loadCurrentUserLoginModelFromDB() {[weak self] success in
            guard let `self` = self else {return}
            HUD.hide()
            self.updateWidtetViewStatus()
             
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
    func clickWidget(item: SWWidgetItem) {
        let editVC = SWymEditVC.init(widgetItem: item)
        pushVC(editVC, animate: true)
    }
}

extension SWymMainVC {
    func setupWidgetView() {
        widgetView.didSelectWidgetItemBlock = { item in
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.clickWidget(item: item)
            }
        }
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







class SWUnlockBgView: UIView {
    
    var cancelBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let bgBtn = UIButton(type: .custom)
        addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        bgBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        
        
        
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = .white
        addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-370)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
            DispatchQueue.main.async {
                bottomBgView.roundCorners([.topLeft, .topRight], radius: 40)
            }
        }
        
        
        let cancelBtn = UIButton(type: .custom)
        bottomBgView.addSubview(cancelBtn)
        cancelBtn.setImage(UIImage(named: "delete_button"), for: .normal)
        cancelBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        
        let contentImageV = UIImageView()
        contentImageV.contentMode = .center
        contentImageV.image = UIImage(named: "popup_lock_ic")
        bottomBgView.addSubview(contentImageV)
        contentImageV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(85)
            $0.width.equalTo(79)
            $0.height.equalTo(72)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        titleLabel.textAlignment = .center
        
        titleLabel.text = "Unlock need cost \(CoinManager.default.coinCostCount) Coins."
        bottomBgView.addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentImageV.snp.bottom).offset(20)
            $0.width.equalTo(220)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        let okBtn = UIButton(type: .custom)
        addSubview(okBtn)
        okBtn.setTitle("Ok", for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        okBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        okBtn.setBackgroundColor(UIColor(hexString: "#131313") ?? .white, for: .normal)
        okBtn.layer.cornerRadius = 24
        okBtn.layer.masksToBounds = true
        okBtn.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(48)
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func cancelBtnClick(sender: UIButton) {
        cancelBtnClickBlock?()
    }
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    
}


