//
//  TBillDetailHeaderView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/16.
//

import UIKit

class TBillDetailHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = mainColor
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerX.top.equalTo(self)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }

        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgView)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
    }
    
    // MARK: - lazy
    lazy var imgView: UIImageView = UIImageView()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
}
