//
//  TCalendarViewController.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/17.
//

import UIKit

class TCalendarViewController: TBaseViewController {
    let manager = TCalendarManager(Date(year:2010, month: 1, day: 1)!,
                                   Date(year:2025, month: 12, day: 1)!)
    private var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Override
    override func setupNav() {
        super.setupNav()
        
        setupNavItems()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(weekView)
        weekView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(40)
        }

        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(weekView.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(50 * 6)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(calendarView.snp.bottom)
        }

        view.addSubview(createBtn)
        createBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view).offset(-40)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
    }
    
    deinit {
        print("Calendar deinit")
    }
    
    override func setupData() {
        calendarView.monthCall = {[weak self] (date) in
            self?.titleView.date = date
        }
        calendarView.dateCall = {[weak self] dateItem in
            guard let self = self else {
                return
            }
            self.currentDate = dateItem.date!

            if dateItem.list.count == 0 {
                self.tableView.billData = []
                return
            }

            let dayBill = TDayBillModel(dateItem.date!.string(), dateItem.list)
            self.tableView.billData = [dayBill]
        }

        let datas: [TCalendarMonthItem] =  manager.calendarData()
        calendarView.datas = datas

        calendarView.layoutIfNeeded()
        self.calendarView.contentOffset = CGPoint(x: CGFloat(self.manager.currentPage()) * KSCREENWIDTH, y: 0)

        fetchData(currentDate)
    }
   
    // MARK: - lazy
    lazy var calendarView: TCMonthView = {
        let view = TCMonthView()
        return view
    }()
    
    lazy var weekView: TCalendarWeekView = {
       let view = TCalendarWeekView()
        return view
    }()
    
    lazy var titleView: TCalendarTitleView = {
        let view = TCalendarTitleView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        view.date = Date()
        return view
    }()
    
    private lazy var tableView: THomeBillTableView = {
        let tableView = THomeBillTableView.init(frame: .zero, style: .grouped)
        return tableView
    }()
    
    lazy var createBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "create"), for: .normal)
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(createDidClick), for: .touchUpInside)
        return btn
    }()
}

//MARK: - Nav
extension TCalendarViewController {
    
    private func setupNavItems() {
        let cancelBtn: UIButton = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(defaultTitleColor, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cancelBtn)
    }
    
    @objc private func cancelButtonClick() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Action
extension TCalendarViewController {
    @objc private func createDidClick() {
        let create = TCreateViewController()
        create.billDate = currentDate
        let createVC = TNavigationController(rootViewController: create)
        
        present(createVC, animated: true, completion: nil)
    }
}

//MARK: - Data
extension TCalendarViewController {
    func fetchData(_ date: Date) {
        let dayBill = TDayBillModel(date.string(), [])
        
        let billList = THomeBillModel.query(date: date)
        dayBill.list = billList
        
        tableView.billData = [dayBill]
    }
}
