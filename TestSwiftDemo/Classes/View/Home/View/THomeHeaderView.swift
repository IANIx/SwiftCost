//
//  THomeHeaderView.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/29.
//

import UIKit
import SnapKit

class THomeHeaderView: UIView {
    var currentDate: Date = Date() {
        didSet {
            updateUI()
        }
    }
    
    var billData: [TDayBillModel] = [] {
        didSet {
            updateUI()
        }
    }
    
    var dateClick: (() -> Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.height.equalTo(60)
        }
        
        contentView.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(contentView)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(contentView)
            make.left.equalTo(leftView.snp.right)
        }
        
        leftView.addSubview(dateYearLabel)
        dateYearLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(leftView)
        }
        
        leftView.addSubview(dateMonthLabel)
        dateMonthLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.bottom.equalTo(leftView).offset(-8)
        }
        
        leftView.addSubview(triangleImgView)
        triangleImgView.snp.makeConstraints { (make) in
            make.left.equalTo(dateMonthLabel.snp.right).offset(10)
            make.bottom.equalTo(leftView).offset(-14)
        }
        
        rightView.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateYearLabel)
            make.left.equalTo(40)
        }
        
        rightView.addSubview(expenditureLabel)
        expenditureLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(incomeLabel)
            make.left.equalTo(180)
        }
        
        rightView.addSubview(incomeAmountLabel)
        incomeAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(incomeLabel)
            make.bottom.equalTo(dateMonthLabel)
        }
        
        rightView.addSubview(expenditureAmountLabel)
        expenditureAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(expenditureLabel)
            make.bottom.equalTo(dateMonthLabel)
        }
    }
        
    // MARK: - lazy
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = mainColor
        return view
    }()
    
    private lazy var leftView: UIView = {
        let view = UIView()
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dateDidClick))
        view.addGestureRecognizer(ges)
        
        let lineView = UIView()
        lineView.backgroundColor = defaultTitleColor
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.width.equalTo(0.5)
            make.top.equalTo(22)
            make.bottom.equalTo(-10)
        }
        
        return view
    }()
    
    private lazy var rightView: UIView = UIView()
    
    private lazy var dateYearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = lightTitleColor
        return label
    }()
    
    private lazy var dateMonthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
    
    private lazy var triangleImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "icon_triangle"))
        return imgView
    }()
    
    private lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = lightTitleColor
        label.text = "收入"
        return label
    }()
    
    private lazy var expenditureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = lightTitleColor
        label.text = "支出"
        return label
    }()
    
    private lazy var incomeAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
    
    private lazy var expenditureAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
}

// MARK: - private
extension THomeHeaderView {
    private func updateUI() {
        dateYearLabel.text = currentDate.string(withFormat: "yyyy年")
        let mutableString = NSMutableAttributedString(string: currentDate.string(withFormat: "MM月"))
        mutableString.addAttributes([.font : UIFont.systemFont(ofSize: 30, weight: .light),
                                     .foregroundColor: defaultTitleColor],
                                    range: NSRange(location: 0, length: 2))
        dateMonthLabel.attributedText = mutableString
        
        var expenses = 0.0
        var income = 0.0
        
        for item in billData {
            for bill in item.list {
                let amount = Double(bill.amount ?? "0") ?? 0.0
                if bill.type == 1 {
                    expenses += amount
                } else {
                    income += amount
                }
            }
        }
                
        let inAmountString = NSMutableAttributedString(string: String(format: "%.2f", income))
        inAmountString.addAttributes([.font : UIFont.systemFont(ofSize: 25, weight: .light),
                                     .foregroundColor: defaultTitleColor],
                                     range: NSRange(location: 0, length: inAmountString.length - 3))
        let exAmountString = NSMutableAttributedString(string: String(format: "%.2f", expenses))
        exAmountString.addAttributes([.font : UIFont.systemFont(ofSize: 25, weight: .light),
                                     .foregroundColor: defaultTitleColor],
                                     range: NSRange(location: 0, length: exAmountString.length - 3))
        
        incomeAmountLabel.attributedText = inAmountString
        expenditureAmountLabel.attributedText = exAmountString
    }
    
    @objc private func dateDidClick() {
        if let dateClick = dateClick {
            dateClick()
        }
    }
}
