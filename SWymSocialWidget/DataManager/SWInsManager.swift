//
//  SWInsManager.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/3.
//

import UIKit


struct SWInsUserInfoItem: Codable {
    var userIconData: Data?
    var userNameStr: String?
    var fullNameStr: String?
    var fanCountStr: String?
    
}

class SWInsManager: NSObject {
    static let `default` = DataManager()
    
    
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        
    }
    
    
}
