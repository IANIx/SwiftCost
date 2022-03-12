//
//  THomeBillTableView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/19.
//

import UIKit

private let HOME_CELL_ID = "HOME_CELL_ID"
class THomeBillTableView: UITableView {
    var billData: [TDayBillModel] = [] {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        dataSource = self
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(THomeTableViewCell.self, forCellReuseIdentifier: HOME_CELL_ID)
        separatorInset = UIEdgeInsets.init(top: 0, left: 65, bottom: 0, right: 0)
        separatorStyle = .none
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension THomeBillTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        billData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = billData[section].list
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HOME_CELL_ID, for: indexPath) as! THomeTableViewCell

        let list = billData[indexPath.section].list
        cell.model = list[indexPath.row]
        cell.lineView.isHidden = (indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController() {
            let vc = TBillDetailViewController()
            let list = billData[indexPath.section].list
            vc.model = list[indexPath.row]
            topVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = THomeTableHeaderView()
        header.dayBill = billData[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return nil
    }
}
