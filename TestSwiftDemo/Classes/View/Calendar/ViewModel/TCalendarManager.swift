//
//  TCalendarManager.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/18.
//

import UIKit

let _monthDateFormat = "yyyyMM"

class TCalendarManager: NSObject {
    var startDate: Date
    var endDate: Date
    private let calendar = Calendar(identifier: .gregorian)


    required init(_ startDate: Date, _ endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func calendarData() -> [TCalendarMonthItem] {
        var datas: [TCalendarMonthItem] = []
        
        let months: DateComponents = calendar.dateComponents([Calendar.Component.month], from: startDate, to: endDate)
        guard let month = months.month else {
            return datas
        }
        
        for i in 0...month {
            guard let date = Calendar.current.date(byAdding: .month, value: i, to: startDate) else {
                continue
            }

            let _days = date.days
            guard _days > 0 else {
                continue
            }
            
            let item = TCalendarMonthItem(date, i)
            datas.append(item)
        }
        
        return datas
    }
    
    func currentPage() -> Int {
        let months: DateComponents = calendar.dateComponents([Calendar.Component.month], from: startDate, to: Date())
        guard let month = months.month else {
            return 0
        }
        
        return month
    }
}
