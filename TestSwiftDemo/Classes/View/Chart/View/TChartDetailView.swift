//
//  TChartDetailView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/11.
//

import UIKit

class TChartDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(16)
            make.top.equalTo(view).offset(10)
        }
        
        view.addSubview(averageTitleLabel)
        averageTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(totalLabel)
            make.top.equalTo(totalLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(maxTitleLabel)
        maxTitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-16)
            make.top.equalTo(averageTitleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(view).offset(-3)
        }
    }
    
    func updateView(_ total: Float = 0.0, _ average: Float = 0.0, _ max: Float = 0.0) {
        totalLabel.text = String(format: "总支出：%.2f", total)
        averageTitleLabel.text = String(format: "平均值：%.2f", average)
        maxTitleLabel.text = String(format: "%.2f", max)
    }
    
    // MARK: - Lazy
    private lazy var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        label.text = "总支出：0.00"
        return label
    }()
    
    private lazy var averageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = defaultTitleColor
        label.text = "平均值：0.00"
        return label
    }()
    
    private lazy var maxTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = defaultTitleColor
        label.text = "0.00"
        return label
    }()

}
