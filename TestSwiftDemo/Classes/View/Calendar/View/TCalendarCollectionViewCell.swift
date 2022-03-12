//
//  TCalendarCollectionViewCell.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/17.
//

import UIKit

class TCalendarCollectionViewCell: UICollectionViewCell {
    var item: TCalendarDateItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lazy
    lazy var circleView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var smallcircleView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = defaultTitleColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
}

// MARK: - Private
extension TCalendarCollectionViewCell {
    
    private func setupUI() {
        
        contentView.addSubview(circleView)
        circleView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        circleView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        
        contentView.addSubview(smallcircleView)
        smallcircleView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 6, height: 6))
            make.top.equalTo(circleView.snp.bottom).offset(2)
            make.centerX.equalTo(contentView)
        }
    }
    
    private func blank() {
        contentLabel.text = ""
        circleView.backgroundColor = UIColor.clear
        smallcircleView.backgroundColor = UIColor.clear
    }
}

// MARK: - Public
extension TCalendarCollectionViewCell {
    
    func updateUI() {
        guard let item = item else {
            blank()
            return
        }
        guard let date = item.date else {
            blank()
            return
        }
        
        contentLabel.text = "\(date.day)"
        item.billList()
        
        if isSelected {
            circleView.backgroundColor = mainColor
        } else {
            if date.isToday {
                circleView.backgroundColor = bodyColor
            } else {
                circleView.backgroundColor = UIColor.clear
            }
        }
        
        smallcircleView.backgroundColor = item.list.count > 0 ? bodyColor : UIColor.clear
    }
}
