//
//  TBillDetailViewController.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/16.
//

import UIKit

private let BILL_DETAIL_CELL_ID = "BILL_DETAIL_CELL_ID"
class TBillDetailViewController: TBaseViewController {
    
    var model: THomeBillModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.header.nameLabel.text = model.name
            self.header.imgView.image = UIImage(named: model.icon ?? "")
            
            let amount = Float(model.amount!) ?? 0.0
            let date = Date(timeIntervalSince1970: model.billTime!)
            details = [
                BillDetail(title: "类型", deail: model.type == 1 ? "支出" : "收入"),
                BillDetail(title: "金额", deail: amount.string()),
                BillDetail(title: "日期", deail: date.string(withFormat: "yyyy年M月d日 EEEE")),
                BillDetail(title: "备注", deail: model.remark ?? model.name!)
            ]
            tableView.reloadData()
        }
    }

    private var details: [BillDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupSubviews() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(60 + bottomPadding)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(TBillDetailTableViewCell.self, forCellReuseIdentifier: BILL_DETAIL_CELL_ID)
        return tableView
    }()
    
    private lazy var header: TBillDetailHeaderView = {
        let view = TBillDetailHeaderView()
        return view
    }()
    
    private lazy var bottomView: TBillDetailBottomView = {
        let view = TBillDetailBottomView()
        view.editBlock = { [weak self] in
            if let self = self, let model = self.model {
                let vc = TCreateViewController()
                vc.model = model
                vc.complete = { [weak self] bill in
                    self?.model = bill
                }
                let nav = TNavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
        }
        
        view.deleteBlock = { [weak self] in
            if let self = self, let model = self.model {
                THomeBillModel.delete(bill: model)
                self.navigationController?.popViewController(animated: true)
            }
        }
        return view
    }()

}

extension TBillDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        details.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BILL_DETAIL_CELL_ID, for: indexPath) as! TBillDetailTableViewCell
        cell.update(details[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.header
    }
    
}
