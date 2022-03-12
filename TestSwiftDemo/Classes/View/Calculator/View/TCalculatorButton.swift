//
//  TCalculatorButton.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/11.
//

import UIKit

class TCalculatorButton: UIButton {
    var type: CalculatorType? {
        didSet {
            switch type {
            case .operate(.del):
                self.setImage(UIImage(named: "delete"), for: .normal)
            case .complete:
                self.backgroundColor = mainColor
            default:
                break
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        //为按钮添加边框
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1).cgColor
        //设置字体与字体颜色
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
