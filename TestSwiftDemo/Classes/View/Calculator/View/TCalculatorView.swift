//
//  TCalculatorView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/11.
//

import UIKit

private let itemRow = 4
private let itemColumn = 4
private let itemH = CGFloat(60.0)
private let itemW = KSCREENWIDTH / CGFloat(itemRow)


class TCalculatorView: UIView {
    private let calculatorList: [CalculatorType] = [
        .number("7"), .number("8"), .number("9"), .calender,
        .number("4"), .number("5"), .number("6"), .operate(.add),
        .number("1"), .number("2"), .number("3"), .operate(.less),
        .number("."), .number("0"), .operate(.del), .complete,
    ]
    private var completeButton: TCalculatorButton?
    private var calendarButton: TCalculatorButton?
    private var operateType: OperateType?
    var completion : TDataBlock<Float>?
    var amount: String = "" {
        didSet {
            total = amount
        }
    }
    var billDate: Date = Date() {
        didSet {
            calendarButton?.setTitle(billDate.string(), for: .normal)
        }
    }
    
    
    private var preTotal: String = ""
    
    private var total: String = "0" {
        didSet {
            if let operate = operateType {
                content = preTotal + operate.description() + total
                completeButton?.setTitle("=", for: .normal)
            } else {
                content = total
                completeButton?.setTitle("完成", for: .normal)
            }
        }
    }
    private var content: String = "0" {
        didSet {
            contentLabel.text = content
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupSubviews()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(itemH * CGFloat(itemColumn))
        }
        
        topView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.right.equalTo(topView).offset(-10)
        }

        for (index, type) in calculatorList.enumerated() {
            let row = CGFloat(index % itemRow)
            let column = CGFloat(index / itemColumn)
            let calculatorBtn = TCalculatorButton.init()
            calculatorBtn.type = type
            calculatorBtn.setTitle(type.description(), for: .normal)
            calculatorBtn.addTarget(self, action: #selector(calculatorDidClick(_:)), for: .touchUpInside)
            bottomView.addSubview(calculatorBtn)
            calculatorBtn.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: itemW, height: itemH))
                make.left.equalTo(bottomView).offset(row * itemW)
                make.bottom.equalTo(bottomView).offset(-(CGFloat(itemColumn) - column - 1) * itemH)
            }

            if type == .complete {
                completeButton = calculatorBtn
            }
            
            if type == .calender {
                calendarButton = calculatorBtn
                calendarButton?.setTitle(billDate.string(), for: .normal)
            }
        }
    }
    
    @objc func calculatorDidClick(_ sender: TCalculatorButton) {
        let type = sender.type
        switch type {
        case .number(let number):
            input(number)
        case .operate(let oper):
            operate(oper)
        case .complete:
            complete()
        default: break
        }
        
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        return view
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = total
        label.font = UIFont.systemFont(ofSize: 27, weight: .regular)
        return label
    }()
}

extension TCalculatorView {
    public func show() {
       isHidden = false
    }
    
    public func dismiss() {
        isHidden = true
        
        operateType = nil
        total = "0"
        preTotal = ""
    }
}

// MARK: - Action
extension TCalculatorView {
    private func input(_ number: String) {
        /// 起始位禁止为.
        if number == "." && total.count == 0 {
            return
        }
        
        if total == "0" && number != "." {
            if number != "0" {
                total = number
            }
            return
        }
        
        if total.contains(".") {
            /// 已经是小数
            if number == "." {
                return
            }
            
            /// 小数最多2位
            if total.last != "." {
                let decimal = total.split(separator: ".").last
                if let dec = decimal, dec.count >= 2 {
                    return
                }
            }
        } else {
            /// 整数最多8位
            if total.count >= 8 {
                return
            }
        }
        
        total.append(number)
    }
    
    private func operate(_ operate: OperateType) {
        switch operate {
        case .add:
            add()
        case .less:
            less()
        case .del:
            del()
        }
        
    }
    
    private func add() {
        if preTotal != "" && operateType != nil {
            calculate()
        } else {
            preTotal = total
        }
        
        operateType = .add
        total = ""
    }
    
    private func less() {
        if preTotal != "" && operateType != nil {
            calculate()
        } else {
            preTotal = total
        }
        
        operateType = .less
        total = ""
    }
    
    private func del() {

        if operateType != nil {
            if total == "" {
                operateType = nil
                total = preTotal
            } else {
                total.removeLast(1)
            }
        } else {
            if total.count == 1 {
                total = "0"
                return
            }
            total.removeLast(1)
        }
        
    }
    
    private func calculate() {
        guard let preTotal_f = Float(preTotal) else {
            return
        }
        
        guard let total_f = Float(total) else {
            return
        }
        
        switch operateType {
        case .add:
            let f = preTotal_f + total_f
            preTotal = f.string()
            
        case .less:
            let f = preTotal_f - total_f
            preTotal = f.string()
            
        default: break
        }
    }
    
    private func complete() {
        guard let _ = operateType else {
            let total_f = Float(total) ?? 0.0
            
            if (total_f == 0.0) {
                print("金额为0")
                return
            }
            
            completion?(total_f)
          return
        }
        
        if preTotal != "" {
            calculate()
        }
        operateType = nil
        total = preTotal
        preTotal = ""
    }
}

//MARK: - Util
extension TCalculatorView {
    
}
