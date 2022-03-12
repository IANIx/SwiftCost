//
//  TChartCategoryTableHeader.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/15.
//

import UIKit

let TChartHeaderHeight = 75 + 150
class TChartTableHeader: UIView {

    var points: [PointEntry] = [] {
        didSet {
            self.chartView.dataEntries = points
            updateDetail(points)
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
        self.addSubview(detailView)
        detailView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
        }
        
        self.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(detailView.snp.bottom)
            make.height.equalTo(150)
        }
        
    }
    
    private func updateDetail(_ points: [PointEntry]) {
        let values = points.map{$0.value}
        let total = values.reduce(0.0, +)
        let average = total / CGFloat(values.count)
        let max = values.max() ?? 0.0

        self.detailView.updateView(Float(total), Float(average),  Float(max))
    }

    
    // MARK: - Lazy
    lazy var chartView: TLineChartView = {
        let chartView = TLineChartView(frame: CGRect(x: 0, y: 70, width: KSCREENWIDTH, height: 150))
        return chartView
    }()
    
    lazy var detailView: TChartDetailView = {
        let detailView = TChartDetailView()
        return detailView
    }()

}
