//
//  InnerDBManager.swift
//  YAO_Core
//
//  Created by Joe on 2020/7/17.
//  Copyright © 2020 JOJO. All rights reserved.
//

import UIKit
import GRDB


protocol DatabaseProtocol: Hashable, Codable, FetchableRecord, MutablePersistableRecord {

}


struct Table {
    var tableName: String?
    var columns: [Column]?

    struct Column {
        var name: String?
        var type: Database.ColumnType?
        var primaryKey: Bool?
        var notNull: Bool?
        var unique: Bool?
        var defaults: DatabaseValueConvertible?
    }

}
class InnerDBManager: NSObject {
    static let `default` = InnerDBManager()
    var dbQueueCommentUserList: DatabaseQueue?
    var dbQueue: DatabaseQueue?
    
    func prepareCommentUserListDatabase() {
        let name = "CommentUserList"
        dbQueueCommentUserList = try? DatabaseQueue(path: self.dbPath(name))
        createCommentDbTables(tables: commentUserListTableProperties())
    }
    
    func prepareDatabase(_ currentUser: String) {
        dbQueue = try? DatabaseQueue(path: self.dbPath(currentUser))
        createDbTables(tables: tableProperties())
    }
    
    fileprivate func dbPath(_ currentUser: String) -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath = documentPaths.first ?? ""
        debugPrint("dbPath: \(documentPath)/\(currentUser).sqlite")
        return "\(documentPath)/\(currentUser).sqlite"
    }
    
    
    
}

extension InnerDBManager {
    func createCommentDbTables(tables: [Table]) {
        do {
            try dbQueueCommentUserList?.write { db in
                try tables.forEach { (table) in
                    try db.create(table: table.tableName ?? "badname", ifNotExists: true) { t in
                        table.columns?.forEach({ (columnData) in
                            let column = t.column(columnData.name ?? "badname", columnData.type)
                            if let defaults = columnData.defaults {
                                column.defaults(to: defaults)
                            }
                            if columnData.primaryKey ?? false {
                                column.primaryKey()
                            }
                            if columnData.notNull ?? false {
                                column.notNull()
                            }
                            if columnData.unique ?? false {
                                column.unique()
                            }
                        })
                    }
                }
            }
        } catch let exception {
            print("SQLite create table failed, exception: \(exception)")
        }
    }
    
    func createDbTables(tables: [Table]) {
        do {
            try dbQueue?.write { db in
                try tables.forEach { (table) in
                    try db.create(table: table.tableName ?? "badname", ifNotExists: true) { t in
                        table.columns?.forEach({ (columnData) in
                            let column = t.column(columnData.name ?? "badname", columnData.type)
                            if let defaults = columnData.defaults {
                                column.defaults(to: defaults)
                            }
                            if columnData.primaryKey ?? false {
                                column.primaryKey()
                            }
                            if columnData.notNull ?? false {
                                column.notNull()
                            }
                            if columnData.unique ?? false {
                                column.unique()
                            }
                        })
                    }
                }
            }
        } catch let exception {
            print("SQLite create table failed, exception: \(exception)")
        }
    }
    
    
    
}

extension InnerDBManager {
    fileprivate func commentUserListTableProperties() -> [Table] {
        return [
            Table(
                tableName: "InnerCommentUserList",
                columns: [
                    Table.Column(name: "userid", type: .text, primaryKey: true, notNull: true, unique: true),
                    Table.Column(name: "username", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "fullname", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "avatarUrl", type: .text, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "cookieStr", type: .text, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "cookieDict", type: .text, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "loginType", type: .text, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "recentlyLoginTime", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
            ])
        ]
    }
}

extension InnerDBManager {
    fileprivate func tableProperties() -> [Table] {
        return [
            Table(
                tableName: "TiktokProfileInfo",
                columns: [
                    Table.Column(name: "userid", type: .text, primaryKey: true, notNull: true, unique: true),
                    Table.Column(name: "username", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "nickname", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "verified", type: .boolean, primaryKey: false, notNull: true, unique: false, defaults: false),
                    Table.Column(name: "isSecret", type: .boolean, primaryKey: false, notNull: true, unique: false, defaults: false),
                    Table.Column(name: "avatarUrl", type: .text, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "followingNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "postsNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "followerNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "likesNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "engagementRate", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "engagementRateRise", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "diggNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "followingRiseNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "followersRiseNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "likesRiseNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "createTime", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "commentNum", type: .integer, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "shareNum", type: .integer, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "viewNum", type: .integer, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    
            ]),
            Table(
                tableName: "VideoInfo",
                columns: [
                    Table.Column(name: "videoId", type: .text, primaryKey: true, notNull: true, unique: true),
                    Table.Column(name: "videoUrl", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "coverUrl", type: .text, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "createDate", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "viewNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "viewNumRise", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "shareNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "shareNumRise", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "shareNumRate", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "likesNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "likesNumRise", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "likesNumRate", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "commentNum", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "commentNumRise", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
                    Table.Column(name: "commentNumRate", type: .double, primaryKey: false, notNull: false, unique: false, defaults: 0),
            ]),
            Table(
                tableName: "GrowthData",
                columns: [
                    Table.Column(name: "growthId", type: .text, primaryKey: true, notNull: true, unique: true, defaults: ""),
                    Table.Column(name: "type", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "titleName", type: .text, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "value", type: .double, primaryKey: false, notNull: true, unique: false, defaults: ""),
                    Table.Column(name: "dayDate", type: .double, primaryKey: false, notNull: false, unique: false, defaults: ""),
                    Table.Column(name: "timestamp", type: .double, primaryKey: false, notNull: false, unique: false, defaults: ""),
            ]),
        ]
    }
}







