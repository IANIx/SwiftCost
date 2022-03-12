//
//  TChartModel.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/15.
//

import Foundation

struct TChartCategoryModel {
    /// 类型
    var type: Int = 1
    
    /// 类别id
    var categoryId: Int = 0
    
    /// 百分比
    var percent: Float = 1

    /// 图标
    var icon: String?

    var name: String?

    /// 金额
    var amount: String
    
    /// 账单列表
    var billList: [THomeBillModel]
}
