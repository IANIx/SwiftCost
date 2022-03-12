//
//  THomeTableHeaderView.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/29.
//

import UIKit
import SnapKit

class THomeTableHeaderView: UIView {
    var dayBill: TDayBillModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.3)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.bottom.equalTo(-10)
        }
        
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.bottom.equalTo(-10)
        }
    }
    
    private func updateUI() {
        guard let dayBill = dayBill else {
            return
        }
        
        guard let date = dayBill.date else {
            return
        }
        
        dateLabel.text = date.string(withFormat: "MM月dd日 EEEE")
      
        var expenses = 0.0
        var income = 0.0
        for bill in dayBill.list {
            let amount = Double(bill.amount ?? "0") ?? 0.0
            if bill.type == 1 {
                expenses += amount
            } else {
                income += amount
            }
        }
        
        detailLabel.text = "\(income > 0 ? "收入: \(Float(income).string())  " : "")" +
            "\(expenses > 0 ? "支出: \(Float(expenses).string())" : "")"
    }
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 174/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1)
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = lightTitleColor
        label.text = "01月31日 星期五"
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = lightTitleColor
        label.text = "支出：6"
        return label
    }()
}
