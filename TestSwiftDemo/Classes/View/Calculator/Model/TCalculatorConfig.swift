//
//  TCalculatorConfig.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/11.
//

import Foundation


enum OperateType {
    case add
    case less
    case del
    
    func description() -> String {
        switch self {
        case .add:
            return "+"
        case .less:
            return "-"
        default:
            return ""
        }
    }
}

enum CalculatorType: Equatable {
    case number(String)
    case operate(OperateType)
    case calender
    case complete
    
    func description() -> String {
        switch self {
        case let .number(value):
            return value
        case let .operate(value):
            return value.description()
        case .complete:
            return "完成"
        default:
            return ""
        }
    }
}

extension Float {
    /// 12.0 -> 12
    /// 12.1 -> 12.1
    /// 12.12 -> 12.12
    /// 12.123 -> 12.12
    public func string() -> String {
        let ff = Float(String(format: "%.2f", self))!
        
        if fmodf(ff, 1) == 0 {
            return String(format: "%d", Int(ff))
        }
        
        if fmodf(ff * 10, 1) == 0 {
            return String(format: "%.1f", ff)
        }
        
        return String(format: "%.2f", ff)
    }

}
