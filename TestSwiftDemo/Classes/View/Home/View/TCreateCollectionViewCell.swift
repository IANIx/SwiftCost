//
//  TCreateCollectionViewCell.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/10.
//

import UIKit

class TCreateCollectionViewCell: UICollectionViewCell {
    var data: TCategoryModel? {
        didSet {
            label.text = data?.name
            if isSelected {
                pictureImageView.image = UIImage(named: data?.icon_s ?? "")
            } else {
                pictureImageView.image = UIImage(named: data?.icon_n ?? "")
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(bodyView)
        bodyView.snp.makeConstraints { (make) in
            make.centerY.width.equalTo(contentView)
        }
        
        bodyView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.width.equalTo(bodyView)
            make.height.equalTo(bodyView.snp.width)
        }
        
        bodyView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(5)
            make.centerX.bottom.equalTo(bodyView)
        }
        
        topView.addSubview(pictureImageView)
        pictureImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(topView)
        }
        
    }
    
    func updateUI() {
        if isSelected {
            pictureImageView.image = UIImage(named: data?.icon_s ?? "")
        } else {
            pictureImageView.image = UIImage(named: data?.icon_n ?? "")
        }
    }
    
    // MARK: - lazy
    lazy var bodyView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = createBodyColor
        view.layer.cornerRadius = contentView.bounds.width/2.0
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    lazy var pictureImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "pruse"))
        img.contentMode = .scaleAspectFill
        return img
    }()
}
