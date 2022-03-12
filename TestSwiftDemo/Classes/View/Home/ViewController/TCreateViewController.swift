//
//  TCreateViewController.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/10.
//

import UIKit
import SnapKit

class TCreateViewController: TBaseViewController {

    var billDate: Date = Date() {
        didSet {
            calculatorView.billDate = billDate
        }
    }
    
    var model: THomeBillModel?
    var complete: TDataBlock<THomeBillModel>?
    
    private var category: TCategoryModel?
    private var total: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Override
    override func setupSubviews() {
        view.addSubview(bodyView)
        bodyView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(view).offset(-AdaptTabHeight)
        }
        
        view.addSubview(calculatorView)
        calculatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-AdaptTabHeight)
        }
        
        bodyView.categoryBlock = {[weak self] category in
            self?.category = category
            self?.calculatorView.show()
        }

        calculatorView.completion = {[weak self] total in
            self?.total = total
            self?.commitBill()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func setupNav() {
        super.setupNav()
        
        setupNavItems()
    }
    
    override func setupData() {
        /// edit
        if let model = self.model {
            bodyView.model = model
            tabView.updateLineView(model.type - 1, false)
            self.calculatorView.amount = model.amount!
            self.calculatorView.show()
        }
    }
    
    private func commitBill() {
        if var model = model {
            if let category = category {
                model.type = category.is_income ? 2 : 1
                model.categoryId = category.category_id
                model.icon = category.icon_l
                model.name = category.name
            }
            
            if let total = total {
                var amount = total.string()
                if total < 0 {
                    amount = (total * -1).string()
                }
                model.amount = amount
            }
            
            model.updateTime = Date().timeIntervalSince1970
            THomeBillModel.update(bill: model)
            if let complete = complete {
                complete(model)
            }
        } else {
            
            guard let category = category, let total = total else {
                return
            }
            
            var amount = total.string()
            if total < 0 {
                amount = (total * -1).string()
            }
                  
            let time = Date().timeIntervalSince1970
            let billTime = billDate.timeIntervalSince1970
            let bill = THomeBillModel(type: category.is_income ? 2 : 1,
                                      categoryId: category.category_id,
                                      icon: category.icon_l,
                                      name: category.name,
                                      amount: amount,
                                      createTime: time,
                                      updateTime: time,
                                      billTime: billTime)
            THomeBillModel.insert(bill: bill)
            if let complete = complete {
                complete(bill)
            }
        }
    }

    // MARK: - lazy
    private lazy var bodyView: TCreateBodyView = {
        let view = TCreateBodyView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var tabView: TCreateTabView = {
        let view = TCreateTabView()
        view.block = {[weak self] (type) in
            self?.bodyView.scrollViewOffset(type == AmountType.expenses ? 0 : 1)
        }
        return view
    }()
    
    private lazy var calculatorView: TCalculatorView = {
        let view = TCalculatorView()
        return view
    }()
}

// MARK: - Nav
extension TCreateViewController {
    
    private func setupNavItems() {
        let cancelBtn: UIButton = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(defaultTitleColor, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
        navigationItem.titleView = tabView
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cancelBtn)
    }
    
    @objc private func cancelButtonClick() {
        dismiss(animated: true, completion: nil)
    }
}
