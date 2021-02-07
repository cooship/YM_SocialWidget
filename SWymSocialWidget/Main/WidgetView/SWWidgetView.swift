//
//  SWWidgetView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit

class SWWidgetView: UIView {

    var upVC: UIViewController?
    let topView = UIView()
    let loginBtn = UIButton(type: .custom)
    let topTitleLabel = UILabel()
    let topUserNameLabel = UILabel()
    
    let typeBgView = UIView()
    let smallBtn = UIButton(type: .custom)
    let mediumBtn = UIButton(type: .custom)
    let largeBtn = UIButton(type: .custom)
    
    let collectionBgView = UIView()
    
    let smallCollection = SWSmallWidgetCollection()
    let mediumCollection = SWMediumWidgetCollection()
    let largeCollection = SWLargeWidgetCollection()
    
    var didSelectWidgetItemBlock: ((_ widgetItem: SWWidgetItem) -> Void)?
    
    
    func showViewStatus(hasUser: Bool) {
        if hasUser {
            loginBtn.isHidden = true
            topUserNameLabel.isHidden = false
            topUserNameLabel.text = "@\(InnerUserManager.default.currentUserInfo?.userName ?? "")"
        } else {
            loginBtn.isHidden = false
            topUserNameLabel.isHidden = true
        }
    }
    
    
    
    
    func refreshContent() {
        smallCollection.collection.reloadData()
        mediumCollection.collection.reloadData()
        largeCollection.collection.reloadData()
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupContentCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        smallBtn.isSelected = true
        mediumBtn.isSelected = false
        largeBtn.isSelected = false
        
        smallCollection.isHidden = false
        mediumCollection.isHidden = true
        largeCollection.isHidden = true
        
    }

}

extension SWWidgetView {
    func setupView() {
        backgroundColor = UIColor(hexString: "#F9F9F7")
        
        // topView
        topView.backgroundColor = .clear
        addSubview(topView)
        topView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        // topTitleLabel
        topTitleLabel.text = "Create a widget "
        topTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        topTitleLabel.textColor = UIColor(hexString: "#131313")
        topView.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.greaterThanOrEqualTo(100)
            $0.height.equalTo(30)
        }
        
        // topUserNameLabel
        topUserNameLabel.text = ""
        topUserNameLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        topUserNameLabel.textColor = UIColor(hexString: "#131313")
        topView.addSubview(topUserNameLabel)
        topUserNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.greaterThanOrEqualTo(50)
            $0.height.equalTo(40)
        }
        
        // loginBtn
        loginBtn.setImage(UIImage(named: "home_log_in_ic"), for: .normal)
        topView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(40)
        }
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        
        // typeBgView
        
        typeBgView.backgroundColor = UIColor(hexString: "#F0F0F0")
        addSubview(typeBgView)
        typeBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
            $0.left.equalTo(24)
            $0.height.equalTo(48)
        }
        typeBgView.layer.cornerRadius = 24
        typeBgView.layer.masksToBounds = true
        
        // smallBtn
        smallBtn.setTitle("Small", for: .normal)
        smallBtn.setTitleColor(UIColor.black.withAlphaComponent(0.4), for: .normal)
        smallBtn.setBackgroundColor(.clear, for: .normal)
        smallBtn.setTitleColor(UIColor.black, for: .selected)
        smallBtn.setBackgroundColor(.white, for: .selected)
        typeBgView.addSubview(smallBtn)
        smallBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(14)
            $0.width.equalTo(100)
            $0.height.equalTo(36)
        }
        smallBtn.layer.cornerRadius = 18
        smallBtn.layer.masksToBounds = true
        smallBtn.addTarget(self, action: #selector(smallBtnClick(sender:)), for: .touchUpInside)
        
        
        // mediumBtn
        mediumBtn.setTitle("Medium", for: .normal)
        mediumBtn.setTitleColor(UIColor.black.withAlphaComponent(0.4), for: .normal)
        mediumBtn.setBackgroundColor(.clear, for: .normal)
        mediumBtn.setTitleColor(UIColor.black, for: .selected)
        mediumBtn.setBackgroundColor(.white, for: .selected)
        typeBgView.addSubview(mediumBtn)
        mediumBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(36)
        }
        mediumBtn.layer.cornerRadius = 18
        mediumBtn.layer.masksToBounds = true
        mediumBtn.addTarget(self, action: #selector(mediumBtnClick(sender:)), for: .touchUpInside)
        
        // mediumBtn
        largeBtn.setTitle("Large", for: .normal)
        largeBtn.setTitleColor(UIColor.black.withAlphaComponent(0.4), for: .normal)
        largeBtn.setBackgroundColor(.clear, for: .normal)
        largeBtn.setTitleColor(UIColor.black, for: .selected)
        largeBtn.setBackgroundColor(.white, for: .selected)
        typeBgView.addSubview(largeBtn)
        largeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(36)
        }
        largeBtn.layer.cornerRadius = 18
        largeBtn.layer.masksToBounds = true
        largeBtn.addTarget(self, action: #selector(largeBtnClick(sender:)), for: .touchUpInside)
        
        // collectionBgView
        collectionBgView.backgroundColor = .clear
        addSubview(collectionBgView)
        collectionBgView.snp.makeConstraints {
            $0.top.equalTo(typeBgView.snp.bottom).offset(10)
            $0.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        
    }
    
    func setupContentCollection() {
        smallCollection.didSelectWidgetItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.didSelectWidgetItemBlock?(item)
        }
        collectionBgView.addSubview(smallCollection)
        smallCollection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        
        mediumCollection.didSelectWidgetItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.didSelectWidgetItemBlock?(item)
        }
        collectionBgView.addSubview(mediumCollection)
        mediumCollection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        
        largeCollection.didSelectWidgetItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.didSelectWidgetItemBlock?(item)
        }
        collectionBgView.addSubview(largeCollection)
        largeCollection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        
        
        
        
    }
}

extension SWWidgetView {
    @objc func loginBtnClick(sender: UIButton) {
        if let fatherVC = self.upVC {
            WILoginHelper.default.showLoginPage(showClose: true, targetViewController: fatherVC) { (success, errorMsg) in
                if success {
                    debugPrint("\(self.className)")
                    // save userlogin info to db
                    InnerUserManager.default.saveAndUpdateCurrentUserInfoToDB()
                    //
                    InnerUserManager.default.loadCurrentUserDetailInfo { (success) in
                        HUD.hide()
                        if success {
                            self.showViewStatus(hasUser: true)
                        } else {
                            self.showViewStatus(hasUser: false)
                            HUD.error("fetch user info error!")
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func smallBtnClick(sender: UIButton) {
        smallBtn.isSelected = true
        mediumBtn.isSelected = false
        largeBtn.isSelected = false
        
        smallCollection.isHidden = false
        mediumCollection.isHidden = true
        largeCollection.isHidden = true
    }
    
    @objc func mediumBtnClick(sender: UIButton) {
        smallBtn.isSelected = false
        mediumBtn.isSelected = true
        largeBtn.isSelected = false
        
        smallCollection.isHidden = true
        mediumCollection.isHidden = false
        largeCollection.isHidden = true
    }
    
    @objc func largeBtnClick(sender: UIButton) {
        smallBtn.isSelected = false
        mediumBtn.isSelected = false
        largeBtn.isSelected = true
        
        smallCollection.isHidden = true
        mediumCollection.isHidden = true
        largeCollection.isHidden = false
    }
    
    
    
}






