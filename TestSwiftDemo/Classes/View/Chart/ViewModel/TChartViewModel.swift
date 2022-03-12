//
//  TChartViewModel.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/7.
//

import UIKit

typealias TChartPointBlock = (_ points: [PointEntry], _ categorys: [TChartCategoryModel]) -> Void

enum ChartDateType: Int {
    case week, month, year
}

struct TChartTabData {
    var dateType: ChartDateType
    var startDate: Date
    var title: String
    var chooseBlock: TVoidBlock? = nil
}

class TChartViewModel: NSObject {
    
    var pointBlock: TChartPointBlock?
    
    override init() {
        super.init()
    }
    
    // MARK: - Lazy
    private lazy var weekTabs: [TChartTabData] = {
        return loadWeekData()
    }()
    
    private lazy var monthTabs: [TChartTabData] = {
        return loadMonthData()
    }()
    
    private lazy var yearTabs: [TChartTabData] = {
        return loadYearData()
    }()
    
    private lazy var allBillData: [THomeBillModel] = {
        return THomeBillModel.queryAll()
    }()
    
    private lazy var firstDate: Date = {
        if allBillData.isEmpty { return Date() }
        return Date(timeIntervalSince1970:allBillData.last?.billTime ?? 0.0)
    }()
    
    private lazy var lastDate: Date = {
        if allBillData.isEmpty { return Date() }
        return Date(timeIntervalSince1970:allBillData.first?.billTime ?? 0.0)
    }()
}

//MARK: - Public
extension TChartViewModel {
    func fetchTabData(_ dateType: ChartDateType) -> [TChartTabData] {
        switch dateType {
        case .week:
            return self.weekTabs
        case .month:
            return self.monthTabs
        case .year:
            return self.yearTabs
        }
    }
}

//MARK: - Private
extension TChartViewModel {
    private func rangeDate(_ startDate: Date, _ dateType: ChartDateType) -> (date1: Date, date2: Date) {
        let date1 = Date(year: startDate.year, month: startDate.month, day: startDate.day)!
        var date2: Date = Date()
        if dateType == .week {
            date2 = Date(timeIntervalSince1970: date1.timeIntervalSince1970 + (7 * 24 * 60 * 60) - 1)
        } else if dateType == .month {
            let days = startDate.days
            let interval = (days * 24 * 60 * 60) - 1
            date2 = Date(timeIntervalSince1970: date1.timeIntervalSince1970 + Double(interval))
        } else {
            let nextYear = Date(year: startDate.year + 1, month: 1, day: 1)!
            date2 = Date(timeIntervalSince1970: nextYear.timeIntervalSince1970 - 1)
        }
        
        return (date1, date2)
    }
    
    private func showMonthDay(_ days: Int, _ day: Int) -> Bool {
        if day == 1 || day == days {
            return true
        }
        
        if days > 30 {
            return day % 5 == 0 && day != 30
        }
        
        return day % 5 == 0
    }
    
    private func categorys(_ bills: [THomeBillModel]) -> [TChartCategoryModel] {
        guard bills.count > 0 else {
            return []
        }
        let total = bills.reduce(into: Float(0.0), { (result, model) in
            let amount = Float(model.amount!) ?? 0.0
            result += amount
        })
        let ids = Set(bills.map { (model) -> Int in
            model.categoryId
        })
        
        var categorys: [TChartCategoryModel] = []
        ids.forEach { (id) in
            let billList = bills.filter({$0.categoryId == id})
            let amount = billList.reduce(into: Float(0.0), { (result, model) in
                let amount = Float(model.amount!) ?? 0.0
                result += amount
            })
            let categoryModel = TChartCategoryModel(type: 1, categoryId: id, percent: amount/total, icon: billList.first?.icon, name: billList.first?.name, amount: String(format: "%.2f", amount), billList: billList)
            categorys.append(categoryModel)
        }
        
        categorys.sort{$0.percent > $1.percent}

        return categorys
    }
}

//MARK: - TabData
extension TChartViewModel {
    private func loadWeekData() -> [TChartTabData] {
        let date1 = firstDate
        let date2 = lastDate
        let component = Calendar.current.dateComponents([.day], from: date1, to: date2)
        guard let day = component.day else {
            return []
        }
        
        let weeks = Int(day/7) + (date1.weekday > date2.weekday ? 1 : 0)
        let components = Calendar.current.dateComponents(
                Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date1)
        var startOfWeek = Calendar.current.date(from: components)!
        var datas: [TChartTabData] = []
        for _ in 0...weeks {
            var tabData = TChartTabData(dateType: .week,
                                        startDate: startOfWeek,
                                        title: "\(startOfWeek.year)-\(startOfWeek.weekOfYear)周")
            
            tabData.chooseBlock = { [weak self] in
                self?.fetchBillData(tabData.startDate, tabData.dateType)
            }
            datas.append(tabData)
            startOfWeek = startOfWeek.adding(day: 7)!
        }
        
        return datas
    }
    
    private func loadMonthData() -> [TChartTabData] {
        let date1 = Date(year: firstDate.year, month: firstDate.month, day: 1)!
        let date2 = Date(year: lastDate.year, month: lastDate.month, day: 1)!
        let component = Calendar.current.dateComponents([.month], from: date1, to: date2)
        guard let month = component.month, var startOfMonth = Date(year: date1.year, month: date1.month, day: 1) else {
            return []
        }
      
        var datas: [TChartTabData] = []
        for _ in 0...month {
            var tabData = TChartTabData(dateType: .month,
                                        startDate: startOfMonth,
                                        title: "\(startOfMonth.isInCurrentYear ? "" : "\(startOfMonth.year)-")" + "\(startOfMonth.month)月")
            
            tabData.chooseBlock = { [weak self] in
                self?.fetchBillData(tabData.startDate, tabData.dateType)
            }
            datas.append(tabData)
            startOfMonth = startOfMonth.adding(month: 1)!
        }
        return datas
    }
    
    private func loadYearData() -> [TChartTabData] {
        let years = lastDate.year - firstDate.year
        
        var datas: [TChartTabData] = []
        for i in 0...years {
            let date = Date(year: firstDate.year + i, month: 1, day: 1)!
            var tabData = TChartTabData(dateType: .year,
                                        startDate: date,
                                        title: "\(date.year)年")
            
            tabData.chooseBlock = { [weak self] in
                self?.fetchBillData(tabData.startDate, tabData.dateType)
            }
            datas.append(tabData)
        }
        return datas
    }
}

//MARK: - BillData
extension TChartViewModel {
    private func fetchBillData(_ startDate: Date, _ dateType: ChartDateType) {
        let data = self.rangeDate(startDate, dateType)
        let date1 = data.date1
        let date2 = data.date2
        
//        print("date1:\(date1.string(withFormat: "YYYY.MM.dd-HH:mm:ss")) - date2:\(date2.string(withFormat: "YYYY.MM.dd-HH:mm:ss"))")
        guard let pointBlock = pointBlock else {
            return
        }

        let billList: [THomeBillModel] = THomeBillModel.query(startTimeInterval: date1.timeIntervalSince1970, endTimeInterval: date2.timeIntervalSince1970).filter({$0.type == AmountType.expenses.rawValue})
        
        if dateType == .year {
            pointBlock(fetchMonthBillData(billList, date1), categorys(billList))
        } else {
            pointBlock(fetchDayBillData(billList, date1, date2, dateType == .week), categorys(billList))
        }
    }
    
    
    private func fetchDayBillData(_ billList: [THomeBillModel], _ date1: Date, _ date2: Date, _ isWeek: Bool) -> [PointEntry] {
        let component = Calendar.current.dateComponents([.day], from: date1, to: date2)
        guard let day = component.day else {
            return []
        }
        
        var points: [PointEntry] = []
        var dayBills: [TDayBillModel] = []
        
        for i in 0...day {
            let dateString = date1.adding(day: i)!.string()
            let dayBill = TDayBillModel(dateString, billList.filter({
                Date(timeIntervalSince1970:$0.billTime ?? 0.0).string() == dateString
            }))
            
            dayBills.append(dayBill)
            
            let result = dayBill.list.reduce(into: Float(0.0), { (result, model) in
                let amount = Float(model.amount!) ?? 0.0
                result += amount
            })
            
            var title = ""
            if isWeek {
                title = dayBill.date?.string(withFormat: "M-dd") ?? ""
            } else {
                if showMonthDay(day + 1, i + 1) {
                    title = dayBill.date?.string(withFormat: "d") ?? ""
                }
            }
            print("data:\(dateString) -- \(result)")
            points.append(PointEntry(CGFloat(result), title, dayBill.list.count > 0))
        }
        
        return points
    }
    
    private func fetchMonthBillData(_ billList: [THomeBillModel], _ date: Date) -> [PointEntry] {
        
        var points: [PointEntry] = []
        let month: [Int] = [1, 3, 6, 9, 12]
        for i in 1...12 {
            let date1 = Date(year: date.year, month: i, day: 1)!
            let days = date1.days
            let dateInterval1: TimeInterval = date1.timeIntervalSince1970
            let dateInterval2: TimeInterval = dateInterval1 + Double((days * 24 * 60 * 60)) - 1
            
            let billData = billList.filter({$0.billTime! >= dateInterval1 && $0.billTime! <= dateInterval2})
            let result = billData.reduce(into: Float(0.0), { (result, model) in
                let amount = Float(model.amount!) ?? 0.0
                result += amount
            })
            
            let title = month.contains(i) ? "\(i)月" : ""
            points.append(PointEntry(CGFloat(result), title, billData.count > 0))
        }
        return points
    }
}
