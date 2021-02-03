//
//  SWStoreView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit
import NoticeObserveKit


class SWStoreView: UIView {
    private var pool = Notice.ObserverPool()
    var upVC: UIViewController?
    let topTitleLabel = UILabel()
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupCollection()
        
        addNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(CoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
            
        }
        .invalidated(by: pool)
    }
    
    func setupView() {
        topTitleLabel.textAlignment = .center
        topTitleLabel.textColor = UIColor.black
        topTitleLabel.text = "Coins Store"
        topTitleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(100)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
        }
        
        let coinIcon = UIImageView()
        coinIcon.contentMode = .center
        coinIcon.image = UIImage(named: "store_coins_ic")
        addSubview(coinIcon)
        coinIcon.snp.makeConstraints {
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(18)
            $0.left.equalTo(24)
            $0.width.height.equalTo(34)
        }
        
        topCoinLabel.textAlignment = .left
        topCoinLabel.text = "\(CoinManager.default.coinCount)"
        addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(coinIcon)
            $0.left.equalTo(coinIcon.snp.right).offset(18)
            $0.height.equalTo(32)
            $0.width.greaterThanOrEqualTo(80)
        }
        
        
    }
    
    
    func setupCollection() {
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        collection.register(cellWithClass: GCStoreCell.self)
    }
    
    func selectCoinItem(item: StoreItem) {
        CoinManager.default.purchaseIapId(iap: item.iapId) { (success, errorString) in
            
            if success {
                CoinManager.default.addCoin(coin: item.coin)
                self.upVC?.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.upVC?.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
}

extension SWStoreView: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withClass: GCStoreCell.self, for: indexPath)
            let item = CoinManager.default.coinIpaItemList[indexPath.item]
            cell.coinCountLabel.text = "x \(item.coin)"
            cell.priceLabel.text = item.price
            return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SWStoreView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
}

extension SWStoreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = CoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class GCStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    
    
    var bgImageV: UIImageView = UIImageView().image("store_coins_bg_ic")
    var coverImageV: UIImageView = UIImageView().image("store_coins_ic")
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.bottom.top.right.equalToSuperview()
            $0.left.equalTo(54)
        }
        
        bgImageV.contentMode = .scaleToFill
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        bgImageV.image = UIImage(named: "sore_bg_ic")
        
        coverImageV.contentMode = .center
        bgView.addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        
        coinCountLabel.textColor = UIColor(hexString: "#000000")
        coinCountLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        bgView.addSubview(coinCountLabel)
        coinCountLabel.textAlignment = .left
        coinCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(coverImageV)
            $0.left.equalTo(coverImageV.snp.right).offset(25)
            $0.right.equalToSuperview().offset(-110)
            $0.height.equalTo(30)
        }
        
        priceLabel.textColor = UIColor(hexString: "#000000")
        priceLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.backgroundColor = .white
        priceLabel.cornerRadius = 8
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(0)
            $0.width.equalTo(110)
            $0.height.equalTo(36)
        }
        priceLabel.layer.masksToBounds = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.priceLabel.roundCorners([.topLeft, .bottomLeft], radius: 18)
            }
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                
            } else {
                
            }
        }
    }
}
