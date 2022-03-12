//
//  TChartTabView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/8.
//

import UIKit

private let tabWidth = 90
let tabHeight = 40

class TChartTabView: UIView {

    var datas: [TChartTabData] = [] {
        didSet {
            updateSubviews()
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
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(tabHeight)
        }
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.hexStringColor(hexString: "#E2E2E2")
        addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    private func updateSubviews() {
        scrollView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        scrollView.contentSize = CGSize(width: tabWidth * datas.count, height: tabHeight)
        for (i, item) in datas.enumerated() {
            let btn = TTabButton(frame: CGRect(x: i * tabWidth, y: 0, width: tabWidth, height: tabHeight), data: item)
            btn.addTarget(self, action: #selector(tabDidClicked(_:)), for: .touchUpInside)
            scrollView.addSubview(btn)
            
            if i == datas.count-1 {
                self.tabDidClicked(btn)
            }
        }
        
        scrollView.addSubview(lineView)
        
        let offsetX = scrollView.contentSize.width > scrollView.frame.width ? scrollView.contentSize.width - scrollView.frame.width : 0
         
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    @objc func tabDidClicked(_ sender: TTabButton) {
        UIView.animate(withDuration: 0.0) {
            self.lineView.frame = CGRect(x: Int(sender.frame.origin.x), y: tabHeight - 2, width: tabWidth, height: 2)
        }
        
        guard let block = sender.data.chooseBlock else {
            return
        }
        block()
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: tabHeight - 2, width: tabWidth, height: 2))
        view.backgroundColor = defaultTitleColor
        return view
    }()
}

class TTabButton: UIButton {
    let data: TChartTabData
    init(frame: CGRect, data: TChartTabData) {
        self.data = data
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        setTitle(data.title, for: .normal)
        setTitleColor(lightTitleColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
