//
//  TCategoryModel.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/12.
//

import UIKit
import ObjectMapper

class TCategoryModel: Mappable {

    var icon_l: String = ""
    var icon_n: String = ""
    var icon_s: String = ""
    var name: String = ""
    var category_id: Int = 0
    var is_income: Bool = true
    var is_system: Bool = true
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        icon_l              <- map["icon_l"]
        icon_n              <- map["icon_n"]
        icon_s              <- map["icon_s"]
        name              <- map["name"]
        is_income              <- map["is_income"]
        is_system              <- map["is_system"]
        category_id              <- map["id"]
    }

}
