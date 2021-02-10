//
//  InnerDBManager+UserInfo.swift
//  YAO_Core
//
//  Created by Joe on 2020/7/18.
//  Copyright © 2020 JOJO. All rights reserved.
//

import Foundation
import GRDB

extension InnerDBManager {
    func insertUserLoginInfo(info: InnerUserLoginModel, completionBlock:((Bool)->Void)) {
        
        guard let queue = dbQueueCommentUserList else {
            completionBlock(false)
            return
        }
        do {
            try queue.write { db in
                
                let userId = info.userProfileInfo.userid?.string ?? ""
                let userName = info.userProfileInfo.username ?? ""
                let fullname = info.userProfileInfo.username ?? ""
                let avatarUrl = info.userProfileInfo.avatarUrl ?? ""
                let cookieStr = info.cookieStr ?? ""
                let cookieDict = info.cookieDict?.jsonString() ?? ""
                let loginType = info.loginType 
                let recentlyLoginTime: Double = Date().timeIntervalSince1970
        
                
                try db.execute(sql: "INSERT OR REPLACE INTO InnerCommentUserList (userid, username, avatarUrl, cookieStr, cookieDict, loginType, recentlyLoginTime) VALUES (?, ?, ?, ?, ?, ?, ?)", arguments: [userId, userName, avatarUrl, cookieStr, cookieDict, loginType, recentlyLoginTime])
                
                
            }
            completionBlock(true)
        } catch  {
            completionBlock(false)
            debugPrint(error)
        }
    }
    
    func selectUserList(completionBlock: (([InnerUserLoginModel])->Void)) {
        guard let queue = dbQueueCommentUserList else {
            completionBlock([])
            return
        }
        
        do {
            try queue.read { db in
                
                let sql = "SELECT * FROM InnerCommentUserList ORDER BY recentlyLoginTime DESC"
                let rows = try Row.fetchCursor(db, sql: sql, adapter: nil)
                var list:[InnerUserLoginModel] = []
                while let row = try rows.next() {
                    let item: InnerUserLoginModel = InnerUserLoginModel.init(row: row)
                    list.append(item)
                }
                completionBlock(list)
            }
        } catch  {
            completionBlock([])
        }
    }
    
    func deleteUserInfo(userId: String, completionBlock: (()->Void)) {
        guard let queue = dbQueueCommentUserList else {
            completionBlock()
            return
        }
        do {
            try queue.write { db in
                try db.execute(sql: "DELETE FROM InnerCommentUserList WHERE userid=\(userId)")
                
            }
            completionBlock()
        } catch  {
            completionBlock()
            debugPrint(error)
        }
    }
    
}












