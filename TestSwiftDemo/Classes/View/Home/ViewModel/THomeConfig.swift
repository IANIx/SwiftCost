//
//  THomeConfig.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/29.
//

import Foundation

/// 金额类型
enum AmountType: Int {
    // 收入
    case income = 2
    // 支出
    case expenses = 1
    
    mutating func description() -> String {
        switch self {
                case .income:
                    return "收入"
                case .expenses:
                    return "支出"
                }
    }
}

/// 类别细分
enum CategoryType: Equatable {
    // 收入
    case income(String?)
    // 支出
    case expenses(String?)
    
    func description() -> String {
        return ""
    }
}
