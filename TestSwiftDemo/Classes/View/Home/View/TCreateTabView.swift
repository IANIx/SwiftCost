//
//  TCreateTabView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/10.
//

import UIKit

typealias TCreateTabBlock = (_ type: AmountType) -> Void

class TCreateTabView: UIView {
    var block: TCreateTabBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TCreateTabView deinit")
    }
    
    private func setupSubviews() {
        addSubview(tabItemView1)
        tabItemView1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 44))
            make.left.top.bottom.equalTo(self)
        }
        
        addSubview(tabItemView2)
        tabItemView2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 44))
            make.right.top.bottom.equalTo(self)
            make.left.equalTo(tabItemView1.snp.right)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(tabItemView1).offset(8)
            make.right.equalTo(tabItemView1).offset(-8)
            make.height.equalTo(2)
        }
    }
    
    func updateLineView(_ index: Int, _ animation: Bool = true) {
        
        let view = index == 0 ? tabItemView1 : tabItemView2
        let lineViewLayout = {
            self.lineView.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(view).offset(8)
                make.right.equalTo(view).offset(-8)
                make.height.equalTo(2)
            }
        }
        
        animation ==  false ? lineViewLayout() :
        UIView.animate(withDuration: 0.3, animations: {
            lineViewLayout()
            self.layoutIfNeeded()
        })
        
    }
    
    // MARK: - Lazy
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private lazy var tabItemView1: TCreateTabItemView = {
        let view =  TCreateTabItemView()
        view.type = .expenses
        view.block = {[weak self] (type) in
            guard let self = self else {
                return
            }
            self.block?(type)
            self.updateLineView(0)
        }
        return view
    }()
    
    private lazy var tabItemView2: TCreateTabItemView = {
        let view =  TCreateTabItemView()
        view.type = .income
        view.block = {[weak self] (type) in
            guard let self = self else {
                return
            }
            self.block?(type)
            self.updateLineView(1)
        }
        return view
    }()
}

class TCreateTabItemView: UIView {
    var block: TCreateTabBlock?

    var type: AmountType? {
        didSet {
            titleLabel.text = type?.description()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        self.addGestureRecognizer(ges)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    @objc func tap() {
        block?(type!)
    }
    
    // MARK: - Lazy
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = defaultTitleColor
        return label
    }()
}
