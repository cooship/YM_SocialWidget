//
//  SWGuideView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/3.
//

import UIKit

class SWGuideView: UIView {

    var upVC: UIViewController?
    let topTitleLabel = UILabel()
    var collection: UICollectionView!
    var pageControl: UIPageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() 
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SWGuideView {
    func setupView() {
        topTitleLabel.textAlignment = .center
        topTitleLabel.textColor = UIColor.black
        topTitleLabel.text = "Instructions"
        topTitleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(100)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(200)
            $0.height.equalTo(20)
        }
        pageControl.currentPage = 0
        pageControl.numberOfPages = DataManager.default.guideList.count
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        
    }
    
    func setupCollection() {
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(10)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
        collection.register(cellWithClass: GCGuideCell.self)
    }
    
}

extension SWGuideView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withClass: GCGuideCell.self, for: indexPath)
        let item = DataManager.default.guideList[indexPath.item]
        cell.guideImageV.image = UIImage.named(item.guideImageName)
        cell.titleLabel.text = item.titleStr
        cell.infoLabel.text = item.infoStr
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.guideList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SWGuideView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width, height: 490)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension SWGuideView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collection {
            let x = (collection.contentOffset.x + (UIScreen.width / 2))
            let y: CGFloat = 100
            let point = CGPoint(x: x, y: y)
            if let index = collection.indexPathForItem(at: point) {
                pageControl.currentPage = index.item
            }
            
        }
    }
    
}







class GCGuideCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var guideImageV: UIImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    var infoLabel: UILabel = UILabel()
    
    
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
            $0.bottom.top.left.right.equalToSuperview()
        }
         
        guideImageV.contentMode = .scaleAspectFit
        bgView.addSubview(guideImageV)
        guideImageV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(300)
        }
        
        titleLabel.textColor = UIColor(hexString: "#000000")
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 18)
        bgView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(guideImageV.snp.bottom).offset(20)
            $0.centerX.equalTo(guideImageV)
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(40)
        }
        
        infoLabel.textColor = UIColor(hexString: "#4D4D4D")
        infoLabel.font = UIFont(name: "Avenir-#4D4D4D", size: 14)
        bgView.addSubview(infoLabel)
        infoLabel.textAlignment = .center
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalTo(guideImageV)
            $0.left.equalTo(50)
            $0.right.equalTo(-50)
            $0.height.greaterThanOrEqualTo(30)
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
