//
//  TDayBillModel.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/19.
//

import UIKit

class TDayBillModel: NSObject {
    var dateStr: String?
    var date: Date?
    var list: [THomeBillModel] = []
    
    init(_ dateStr: String, _ list: [THomeBillModel]) {
        self.dateStr = dateStr
        self.list = list
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self.date = dateFormatter.date(from: dateStr)
    }
}
