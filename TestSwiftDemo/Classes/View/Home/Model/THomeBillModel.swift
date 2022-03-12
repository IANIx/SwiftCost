//
//  THomeBillModel.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/29.
//

import UIKit
import GRDB

struct THomeBillModel: Codable {
    /// 类型
    var type: Int = 1
    
    /// 类别id
    var categoryId: Int = 0

    /// 图标
    var icon: String?

    var name: String?

    /// 备注
    var remark: String?

    /// 金额
    var amount: String?
    
    /// 创建日期
    var createTime: Double?
    
    /// 更新日期
    var updateTime: Double?
    
    /// 账单日期
    var billTime: Double?
    
    var id: Int?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        case id
        case type
        case categoryId
        case icon
        case name
        case remark
        case amount
        case createTime
        case updateTime
        case billTime
   }
}

extension THomeBillModel: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbQueue: DatabaseQueue = DBManager.dbQueue
    
    static var databaseTableName: String = TableName.billList
    
    //MARK: 创建
    /// 创建数据库
    private static func createTable() -> Void {
        try! self.dbQueue.inDatabase { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(TableName.billList) {
//                debugPrint("表已经存在")
                return
            }
            // 创建数据库表
            try db.create(table: TableName.billList, temporary: false, ifNotExists: true, body: { (t) in
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                t.column(Columns.type.rawValue, Database.ColumnType.integer)
                t.column(Columns.categoryId.rawValue, Database.ColumnType.integer)
                t.column(Columns.icon.rawValue, Database.ColumnType.text)
                t.column(Columns.name.rawValue, Database.ColumnType.text)
                t.column(Columns.remark.rawValue, Database.ColumnType.text)
                t.column(Columns.amount.rawValue, Database.ColumnType.text)
                t.column(Columns.createTime.rawValue, Database.ColumnType.double)
                t.column(Columns.updateTime.rawValue, Database.ColumnType.double)
                t.column(Columns.billTime.rawValue, Database.ColumnType.double)
            })
        }
    }
    
    //MARK: 插入
    /// 插入单个数据
    static func insert(bill: THomeBillModel) -> Void {
        // 创建表
        self.createTable()
        // 事务
        try! self.dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                var billTemp = bill
                // 插入到数据库
                try billTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        }
    }
    
    //MARK: 查询
    /// 根据名称查询
    static func query(name: String) -> [THomeBillModel] {
        // 创建数据库
        self.createTable()
        // 返回查询结果
        return try! self.dbQueue.unsafeRead({ (db) -> [THomeBillModel] in
            return try THomeBillModel.filter(Column(Columns.name.rawValue) == name)
                .order(Column(Columns.billTime.rawValue).desc)
                .fetchAll(db)
        })
    }
    
    /// 按天查询
    static func query(date: Date) -> [THomeBillModel] {
        // 创建数据库
        self.createTable()
        
        let components = Calendar.current.dateComponents([.year,.month,.day], from: date)
        guard let startTimeInterval = Calendar.current.date(from: components)?.timeIntervalSince1970 else { return [] }
        let endTimeInterval = startTimeInterval + Double(24 * 60 * 60)
        
        // 返回查询结果
        return try! self.dbQueue.unsafeRead({ (db) -> [THomeBillModel] in
            return try THomeBillModel.filter(Column(Columns.billTime.rawValue) >= startTimeInterval &&
                                                Column(Columns.billTime.rawValue) < endTimeInterval)
                .order(Column(Columns.updateTime.rawValue).desc)
                .fetchAll(db)
        })
    }
    
    /// 按月查询
    static func query(monthDate: Date) -> [THomeBillModel] {
        // 创建数据库
        self.createTable()
        
        let components = Calendar.current.dateComponents([.year, .month], from: monthDate)
        guard let startTimeInterval = Calendar.current.date(from: components)?.timeIntervalSince1970 else { return [] }
        let days = Calendar.current.range(of: .day, in: .month, for: monthDate)?.count ?? 0
        let endTimeInterval = startTimeInterval + Double(days * 24 * 60 * 60)
        
        // 返回查询结果
        return try! self.dbQueue.unsafeRead({ (db) -> [THomeBillModel] in
            return try THomeBillModel.filter(Column(Columns.billTime.rawValue) >= startTimeInterval &&
                                                Column(Columns.billTime.rawValue) < endTimeInterval)
                .order(Column(Columns.billTime.rawValue).desc)
                .fetchAll(db)
        })
    }
    
    /// 分段查询
    static func query(startTimeInterval: Double, endTimeInterval: Double) -> [THomeBillModel] {
        // 创建数据库
        self.createTable()
        
        // 返回查询结果
        return try! self.dbQueue.unsafeRead({ (db) -> [THomeBillModel] in
            return try THomeBillModel.filter(Column(Columns.billTime.rawValue) >= startTimeInterval &&
                                                Column(Columns.billTime.rawValue) < endTimeInterval)
                .order(Column(Columns.billTime.rawValue).desc)
                .fetchAll(db)
        })
    }
    
    /// 查询所有
    static func queryAll() -> [THomeBillModel] {
        // 创建数据库
        self.createTable()
        // 返回查询结果
        return try! self.dbQueue.unsafeRead({ (db) -> [THomeBillModel] in
            return try THomeBillModel.order(Column(Columns.billTime.rawValue).desc)
                .fetchAll(db)
        })
    }
    
    //MARK: 更新
    /// 更新
    static func update(bill: THomeBillModel) -> Void {
        /// 创建数据库表
        self.createTable()
        // 事务 更新场景
        try! self.dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                try bill.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        }
    }
        
    /// 删除单个账单
    static func delete(bill: THomeBillModel) -> Void {
        // 是否有数据库表
        self.createTable()
        // 事务
        try! self.dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try bill.delete(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        }
    }
}
