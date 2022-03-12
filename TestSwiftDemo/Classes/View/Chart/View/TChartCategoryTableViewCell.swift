//
//  TChartCategoryTableViewCell.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/15.
//

import UIKit

class TChartCategoryTableViewCell: UITableViewCell {
    var caregoryModel: TChartCategoryModel? {
        didSet {
            updateUI()
        }
    }
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 174/255.0, green: 173/255.0, blue: 173/255.0, alpha: 0.5)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        contentView.addSubview(detaiView)
        detaiView.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(imgView)
        }
        
        detaiView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(detaiView)
            make.left.equalTo(detaiView)
        }
        
        detaiView.addSubview(amoutLabel)
        amoutLabel.snp.makeConstraints { (make) in
            make.top.right.equalTo(detaiView)
        }

        detaiView.addSubview(progessView)
        progessView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.bottom.equalTo(detaiView)
            make.height.equalTo(8)
            make.left.equalTo(detaiView)
            make.width.equalToSuperview().multipliedBy(0.0)
        }

        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
            make.left.equalTo(detaiView)
            make.height.equalTo(0.2)
        }
    }
    
    private func updateUI() {
        guard let caregoryModel = caregoryModel else {
            return
        }

        let percent = caregoryModel.percent * 100
        imgView.image = UIImage(named: caregoryModel.icon ?? "")
        nameLabel.text = "\(caregoryModel.name ?? "")  \(String(format: "%.1f", percent))%"
        amoutLabel.text = caregoryModel.amount
        
        progessView.snp.remakeConstraints { (make) in
            
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.bottom.equalTo(detaiView)
            make.height.equalTo(8)
            make.left.equalTo(detaiView)
            make.width.equalToSuperview().multipliedBy(caregoryModel.percent)

        }
    }
    
    // MARK: - lazy
    private lazy var imgView: UIImageView = UIImageView()
    private lazy var detaiView: UIView = UIView()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        label.text = "购物  67.89%"
        return label
    }()
    
    private lazy var amoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        label.text = "0.00"
        return label
    }()
    
    private lazy var progessView: UIView = {
        let view = UIView()
        view.backgroundColor = mainColor
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    
}
