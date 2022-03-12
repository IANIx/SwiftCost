//
//  TCategoryViewModel.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/12.
//

import UIKit
import SwiftyJSON

/// 所有类别数据
class TCategoryViewModel: NSObject {
    static let shared = TCategoryViewModel()
    var expensesList: [TCategoryModel] = []
    var incomeList: [TCategoryModel] = []

    override init() {
        super.init()
    }
    
    func loadData() {
        guard let path = Bundle.main.url(forResource: "data", withExtension: "plist") else {
            return
        }
        guard let data = try? Data(contentsOf: path) else {
            return
        }
        
        let swiftDic = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSDictionary
        let dataDit = JSON(swiftDic)
        dataDit["expenses"].forEach { (str, json) in
            expensesList.append(TCategoryModel(JSON: json.dictionaryObject!)!)
        }
     
        dataDit["income"].forEach { (str, json) in
            incomeList.append(TCategoryModel(JSON: json.dictionaryObject!)!)
        }
    }

}
