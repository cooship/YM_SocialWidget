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
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        guideList = self.loadJson([GCGuideItem].self, name: "GuideInfoList") ?? []
    }
    
}
