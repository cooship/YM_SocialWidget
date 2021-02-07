//
//  SWSmallWidgetView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit

class SWSmallWidgetCollection: UIView {
    var collection: UICollectionView!
    var didSelectWidgetItemBlock: ((_ widgetItem: SWWidgetItem) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 
extension SWSmallWidgetCollection {
    func setupView() {
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
            $0.bottom.top.equalToSuperview()
            $0.right.equalToSuperview()
            
        }
        collection.register(cellWithClass: SmallWidgetCell.self)
    }
   
   
}

extension SWSmallWidgetCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: SmallWidgetCell.self, for: indexPath)
        let item = SWWidgetManager.default.smallList[indexPath.item]
        
        cell.contentImageView.image = UIImage(named: item.thumbnail ?? "")
        cell.contentImageView.layer.cornerRadius = 8
        cell.contentImageView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor(hexString: "#EFEFEF")?.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 8
        
        if ITContentPurchasedUnlockManager.sharedInstance().hasUnlockContent(withContentItemId: item.thumbnail ?? "") {
            cell.lockImageView.isHidden = true
        } else {
            cell.lockImageView.isHidden = false
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SWWidgetManager.default.smallList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SWSmallWidgetCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding = ((UIScreen.width - 160 * 2 - 2) / 3)
        return UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension SWSmallWidgetCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = SWWidgetManager.default.smallList[indexPath.item]
        didSelectWidgetItemBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class SmallWidgetCell: UICollectionViewCell {
    var contentImageView: UIImageView = UIImageView()
    let lockImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImageView.contentMode = .scaleAspectFit
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
         
        contentView.addSubview(lockImageView)
        lockImageView.image = UIImage(named: "lock_ic")
        lockImageView.contentMode = .center
        lockImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(20)
        }
        lockImageView.isHidden = true
    }
    
    
    
}





