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
        
        textColors = ["#FFFFFF", "#000000", "#29B7FE", "#FF9997", "#FFFF00", "#03FE00", "#D7EF90", "#21B3F1", "#21BFF1"]
        textFontNames = ["Avenir-Heavy", "AppleSDGothicNeo-Regular", "AlNile-Bold", "SnellRoundhand-Bold", "Thonburi-Bold", "TrebuchetMS", "Verdana", "ZapfDingbatsITC", "SnellRoundhand", "PingFangHK-Semibold"]
        
        bgColors = ["#FFFFFF", "#000000", "#29B7FE", "#FF9997", "#FFFF00", "#03FE00", "#D7EF90", "#21B3F1", "#21BFF1"]
        
        
        
        
        
    }
    
}
