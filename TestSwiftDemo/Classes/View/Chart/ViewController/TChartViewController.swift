//
//  TChartViewController.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import UIKit

class TChartViewController: TBaseViewController {

    var list: [PointEntry] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupSubviews() {
        let segmentView = UIView(frame: CGRect(x: 0, y: 0, width: KSCREENWIDTH, height: 50))
        segmentView.backgroundColor = mainColor
        self.view.addSubview(segmentView)
        segmentView.addSubview(segment)
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(segmentView.snp.bottom)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(tabView.snp.bottom)
        }
    }
    
    override func setupData() {
        tabView.datas = viewModel.fetchTabData(.week)
    }
    
    @objc func segmentDidClick(_ sender: UISegmentedControl) {
        tabView.datas = viewModel.fetchTabData(ChartDateType(rawValue: sender.selectedSegmentIndex) ?? .week)
    }

    // MARK: - Lazy
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["周", "月", "年"])
        segment.frame = CGRect(x: 10, y: 10, width: KSCREENWIDTH - 20, height: 30)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentDidClick(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var tabView: TChartTabView = {
       let view = TChartTabView()
        return view
    }()
    
    
    lazy var tableView: TChartTableView = {
        let tableView = TChartTableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    
    lazy var viewModel: TChartViewModel = {
        let viewModel = TChartViewModel()
        viewModel.pointBlock = {[weak self] (points, categorys) in
            self?.tableView.points = points
            self?.tableView.categoryList = categorys
        }
        return viewModel
    }()
}
