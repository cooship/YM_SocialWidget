//
//  SWTextToolView.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/4.
//

import UIKit

class SWTextToolView: UIView {

    let bgView = UIView()
    var collectionColor: UICollectionView!
    var collectionFont: UICollectionView!
    
    var didSelectColorBlock: ((_ color: String) -> Void)?
    var didSelectFontBlock: ((_ fontName: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#F1F1EF")
        setupView()
        setupCollectionColor()
        setupCollectionFont()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SWTextToolView {
    func setupView() {
        
        bgView.backgroundColor = .white
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().offset(34)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            [weak self] in
            guard let `self` = self else {return}
            self.bgView.roundCorners([.topLeft, .bottomLeft], radius: 60)
        }
        
        
    }
    
    func setupCollectionColor() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionColor = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionColor.showsVerticalScrollIndicator = false
        collectionColor.showsHorizontalScrollIndicator = false
        collectionColor.backgroundColor = .clear
        collectionColor.delegate = self
        collectionColor.dataSource = self
        bgView.addSubview(collectionColor)
        collectionColor.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
        }
        collectionColor.register(cellWithClass: SWColorCell.self)
    }
    
    
    func setupCollectionFont() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionFont = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionFont.showsVerticalScrollIndicator = false
        collectionFont.showsHorizontalScrollIndicator = false
        collectionFont.backgroundColor = .clear
        collectionFont.delegate = self
        collectionFont.dataSource = self
        bgView.addSubview(collectionFont)
        collectionFont.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
        }
        collectionFont.register(cellWithClass: SWTextCell.self)
    }
    
}
    
extension SWTextToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionColor {
            let cell = collectionView.dequeueReusableCell(withClass: SWColorCell.self, for: indexPath)
            let item = DataManager.default.textColors[indexPath.item]
            cell.colorView.backgroundColor = UIColor(hexString: item)
            cell.colorView.layer.cornerRadius = 16
            cell.colorView.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            
            if item.contains("FFFFFF") {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor(hexString: "#DEDEDE")?.cgColor
            } else {
                cell.layer.borderWidth = 0
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: SWTextCell.self, for: indexPath)
            
            let item = DataManager.default.textFontNames[indexPath.item]
            
            cell.textLabel.text = "Font"
            cell.textLabel.font = UIFont(name: item, size: 12)
            
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionColor {
            return DataManager.default.bgColors.count
        } else {
            return DataManager.default.textFontNames.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SWTextToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionColor {
            return CGSize(width: 32, height: 32)
        } else {
            return CGSize(width: 50, height: 32)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension SWTextToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionColor {
            let color = DataManager.default.bgColors[indexPath.item]
            didSelectColorBlock?(color)
        } else {
            let fontName = DataManager.default.textFontNames[indexPath.item]
            didSelectFontBlock?(fontName)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

    

class SWTextCell: UICollectionViewCell {
    
    let textLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
         
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                textLabel.textColor = .black
                textLabel.font = UIFont(name: textLabel.font.fontName, size: 14)
            } else {
                textLabel.textColor = UIColor(hexString: "#A5A5A5")
                textLabel.font = UIFont(name: textLabel.font.fontName, size: 12)
            }
        }
    }
    
}
    
    
    

