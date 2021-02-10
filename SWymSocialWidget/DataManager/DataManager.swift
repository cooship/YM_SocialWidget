//
//  DataManager.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit

class GCGuideItem: Codable {
    let guideImageName : String
    let titleStr : String
    let infoStr : String
}

class DataManager: NSObject {
    static let `default` = DataManager()
    var guideList : [GCGuideItem] = []
    var textColors: [String] = []
    var textFontNames: [String] = []
    var bgColors: [String] = []
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        guideList = self.loadJson([GCGuideItem].self, name: "GuideInfoList") ?? []
        
        textColors = ["#000000","#FFFFFF","#FFB6C1","#FF69B4","#FF00FF","#7B68EE","#0000FF","#4169E1","#00BFFF","#00FFFF","#F5FFFA","#3CB371","#98FB98","#32CD32","#FFFF00","#FFD700","#FFA500","#FF7F50","#CD853F","#00FA9A"]
        textFontNames = ["Avenir-Heavy", "Baskerville-BoldItalic", "ChalkboardSE-Bold", "Courier-BoldOblique", "DamascusSemiBold", "Didot-Bold", "DINCondensed-Bold", "Futura-MediumItalic", "Georgia-Bold", "KohinoorBangla-Semibold", "NotoSansKannada-Bold", "Palatino-BoldItalic", "SnellRoundhand-Bold", "Verdana-Bold", "DamascusSemiBold", "GillSans-Bold", "Rockwell-Bold", "TrebuchetMS-Bold"]
        
        bgColors = ["#000000","#FFFFFF","#FFB6C1","#FF69B4","#FF00FF","#7B68EE","#0000FF","#4169E1","#00BFFF","#00FFFF","#F5FFFA","#3CB371","#98FB98","#32CD32","#FFFF00","#FFD700","#FFA500","#FF7F50","#CD853F","#00FA9A"]
        
        
        
        
        
    }
    
}
