//
//  TCalendarVariables.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/18.
//

import Foundation

extension Date {
    
    ///
    ///     let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7:45 PM"
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    public init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day) {
    
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.year = year
        components.month = month
        components.day = day
    
        if let date = calendar?.date(from: components) {
            self = date
        } else {
            return nil
        }
    }
    
    
    public var calendar: Calendar {
        return Calendar.current
    }
    
    ///
    /// Date().year -> 2017
    ///
    /// var someDate = Date()
    /// someDate.year = 2000 // sets someDate's year to 2000
    ///
    public var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
   ///
   /// Date().month -> 1
   ///
   /// var someDate = Date()
   /// someDate.month = 10 // sets someDate's month to 10.
   ///
   public var month: Int {
       get {
           return Calendar.current.component(.month, from: self)
       }
       set {
           let allowedRange = Calendar.current.range(of: .month, in: .year, for: self)!
           guard allowedRange.contains(newValue) else { return }
   
           let currentMonth = Calendar.current.component(.month, from: self)
           let monthsToAdd = newValue - currentMonth
           if let date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self) {
               self = date
           }
       }
   }
    
    ///
    /// Date().day -> 12
    ///
    /// var someDate = Date()
    /// someDate.day = 1 // sets someDate's day of month to 1.
    ///
    public var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
    
            let currentDay = Calendar.current.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    ///
    /// Date().weekday -> 5 // fifth day in the current week.
    /// 星期几
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    ///
    /// Date().weekOfYear -> 2 // second week in the year.
    /// 一年中的第几周
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
   ///
   /// Date().weekOfMonth -> 3 // date is in third week of the month.
   /// 一月中的第几周
   public var weekOfMonth: Int {
       return Calendar.current.component(.weekOfMonth, from: self)
   }
    
    /// 一月有多少天
    public var days: Int {
        return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
    }
   ///
   /// Date().isInToday -> true
   /// 是否在今天
   public var isToday: Bool {
       return Calendar.current.isDateInToday(self)
   }
    
    /// 是否在当前月内
    public var isInCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// 是否在当前月内
    public var isInCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// 获取几天后/前的日期
    public func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: day, to: self)
    }
    
    /// 获取几个月后/前的日期
    public func adding(month: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: month, to: self)
    }
    
    /// 日期格式化
    public func string(withFormat format: String = "yyyMMdd") -> String {
        let dateFormatter = DateFormatter(withFormat: format, locale: "zh")
        return dateFormatter.string(from: self)
    }

}
