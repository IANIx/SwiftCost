//
//  TChartCategoryView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/15.
//

import UIKit

private let CHART_CELL_ID = "CHART_CELL_ID"
class TChartTableView: UITableView {
    
    var categoryList: [TChartCategoryModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    var points: [PointEntry] = [] {
        didSet {
            self.header.points = points
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
        register(TChartCategoryTableViewCell.self, forCellReuseIdentifier: CHART_CELL_ID)
        separatorInset = UIEdgeInsets.init(top: 0, left: 65, bottom: 0, right: 0)
        separatorStyle = .none
    }
    
    private lazy var header: TChartTableHeader = TChartTableHeader()
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TChartTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(TChartHeaderHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CHART_CELL_ID, for: indexPath) as! TChartCategoryTableViewCell
        cell.caregoryModel = categoryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return nil
    }
}
