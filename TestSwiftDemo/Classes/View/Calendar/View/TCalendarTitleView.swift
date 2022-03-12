//
//  TCalendarTitleView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/18.
//

import UIKit

class TCalendarTitleView: UIView {
    var date: Date? {
        didSet {
            if let date = date {
                contentLabel.text = date.string(withFormat: "yyyy年MM月")
            }
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
        let view = UIView()
        
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(view)
        }
        
        view.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel.snp.right).offset(8)
            make.centerY.right.equalTo(view)
            make.size.equalTo(CGSize(width: 12, height: 17))
        }
    }

    // MARK: - lazy
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = defaultTitleColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    lazy var img: UIImageView = {
        let img = UIImageView(image: UIImage(named: "icon_triangle"))
        return img
    }()
}
