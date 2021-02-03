//
//  SWWidgetManager.swift
//  SWymSocialWidget
//
//  Created by JOJO on 2021/2/2.
//

import UIKit



struct SWWidgetItem: Codable {
    var widthSize: String? = "small" // small medium large
    var thumbnail: String? = ""
    var profileImgData: Data?
    var bgImgData: Data?
    var userName: String?
    var fullName: String?
    var fansCount: String?
    
    
}

class SWWidgetManager: NSObject {

    static let `default` = SWWidgetManager()
    
    var smallList: [SWWidgetItem] = []
    var mediumList: [SWWidgetItem] = []
    var largeList: [SWWidgetItem] = []
    
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        
        smallList = self.loadJson([SWWidgetItem].self, name: "SmallWidgetList") ?? []
        
        mediumList = self.loadJson([SWWidgetItem].self, name: "MediumWidgetList") ?? []
        
        largeList = self.loadJson([SWWidgetItem].self, name: "LargetWidgetList") ?? []
    }
    
}

extension NSObject {
    func loadJson<T: Codable>(_: T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}
