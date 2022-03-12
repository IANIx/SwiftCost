//
//  TCalendarItem.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/18.
//

import UIKit

struct TCalendarMonthItem {
    var date: Date?
    var monthStr = ""
    var index = 0
    var days = 0
    
    init(_ date: Date? = nil, _ index: Int = 0) {
        self.date = date
        self.index = index
    }
    
    lazy var dateList: [TCalendarDateItem] = {
        guard let date = date else {
            return []
        }
        
        var list: [TCalendarDateItem] = []
        let week = Date(year: date.year, month: date.month, day: 1)?.weekday ?? 0
        let _days = date.days
        
        for _ in 1..<week {
            list.append(TCalendarDateItem())
        }
        for j in 1..._days {
            list.append(TCalendarDateItem(Date(year: date.year, month: date.month, day: j)))
        }
       return list
    }()
    
}

class TCalendarDateItem: NSObject {
    var date: Date?
    
    var list: [THomeBillModel] = []
    
    func billList() {
        guard let date = date else {
            return
        }
        let _list = THomeBillModel.query(date: date)
        list = _list
    }
    
    init(_ date: Date? = nil) {
        self.date = date
    }
    
}
