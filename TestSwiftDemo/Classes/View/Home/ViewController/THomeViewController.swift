//
//  THomeViewController.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import UIKit
import SnapKit

class THomeViewController: TBaseViewController {
    var billData: [TDayBillModel] = []
    var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Override
    override func setupSubviews() {
        view.addSubview(homeHeaderView)
        homeHeaderView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(homeHeaderView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }

    override func setupNav() {
        super.setupNav()
        setupNavItems()
    }
        
    // MARK: - Lazy
    private lazy var homeHeaderView: THomeHeaderView = {
        let view = THomeHeaderView()
        view.dateClick = { [weak self] in
            guard let self = self else {
                return
            }
            TPicker.showDatePicker(date: self.currentDate) { (date) in
                self.currentDate = date
                self.loadData()
            }
        }
        return view
    }()
    
    private lazy var tableView: THomeBillTableView = {
        let tableView = THomeBillTableView.init(frame: .zero, style: .grouped)
        return tableView
    }()
}

// MARK: - Nav
extension THomeViewController {
    private func setupNavItems() {
        let addBtn: UIButton = UIButton(type: .custom)
        addBtn.setImage(UIImage.init(named: "add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        
        let calendarBtn: UIButton = UIButton(type: .custom)
        calendarBtn.setImage(UIImage.init(named: "calendar"), for: .normal)
        calendarBtn.addTarget(self, action: #selector(calendarButtonClick), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: calendarBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addBtn)
    }
    
    @objc private func addButtonClick() {
        let createVC = TNavigationController(rootViewController: TCreateViewController())
        createVC.modalPresentationStyle = .fullScreen
        
        present(createVC, animated: true, completion: nil)
    }
    
    @objc private func calendarButtonClick() {
        let calendarVC = TNavigationController(rootViewController: TCalendarViewController())
        calendarVC.modalPresentationStyle = .fullScreen
        
        present(calendarVC, animated: true, completion: nil)
    }
}

// MARK: - Data
extension THomeViewController {
    func loadData() {
        billData.removeAll()
        let billList = THomeBillModel.query(monthDate: currentDate)
        
        for bill in billList {
            let date = Date(timeIntervalSince1970:bill.billTime ?? 0.0)
            let format = DateFormatter(withFormat: "yyyyMMdd", locale: "zh")
            let dateString = format.string(from: date)
            
            var dayBill: TDayBillModel? = billData.first { (_bill) -> Bool in
                _bill.dateStr == dateString
            }
            
            if dayBill == nil {
                dayBill = TDayBillModel(dateString, [])
                billData.append(dayBill!)
            }
            
            dayBill!.list.append(bill)
            dayBill!.list.sort { $0.updateTime! > $1.updateTime! }
        }

        tableView.billData = billData
        homeHeaderView.currentDate = currentDate
        homeHeaderView.billData = billData
    }
}

