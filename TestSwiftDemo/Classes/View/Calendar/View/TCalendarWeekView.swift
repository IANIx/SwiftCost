//
//  TCalendarWeekView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/18.
//

import UIKit

class TCalendarWeekView: UIView {
    let weekStr: [String] = ["日", "一", "二", "三", "四", "五", "六",]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        let width = KSCREENWIDTH/CGFloat(weekStr.count)
        for i in 0..<weekStr.count {
            let label = UILabel()
            label.text = weekStr[i]
            label.textColor = lightTitleColor
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            label.textAlignment = .center
            addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(self)
                make.left.equalTo(self).offset(width * CGFloat(i))
                make.width.equalTo(width)
            }
        }
    }
}
