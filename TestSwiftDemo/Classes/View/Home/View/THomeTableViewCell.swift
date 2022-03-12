//
//  THomeTableViewCell.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/29.
//

import UIKit

class THomeTableViewCell: UITableViewCell {
    var model: THomeBillModel? {
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
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(imgView.snp.right).offset(16)
        }
        
        contentView.addSubview(amoutLabel)
        amoutLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-16)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(65)
            make.height.equalTo(0.2)
        }
    }
    
    private func updateUI() {
        guard let model = model else {
            return
        }
        
        let amount = Float(model.amount!) ?? 0.0
        let amountStr = (model.type == 1 ? amount * -1 : amount).string()
        
        imgView.image = UIImage(named: model.icon ?? "")
        nameLabel.text = model.name ?? ""
        amoutLabel.text = amountStr
    }
    
    // MARK: - lazy
    private lazy var imgView: UIImageView = UIImageView()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
    
    private lazy var amoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
}
