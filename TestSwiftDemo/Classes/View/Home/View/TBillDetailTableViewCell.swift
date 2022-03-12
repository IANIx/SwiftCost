//
//  TBillDetailTableViewCell.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/16.
//

import UIKit

class TBillDetailTableViewCell: UITableViewCell {

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
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
        }
        
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(nameLabel.snp.right).offset(16)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
            make.height.equalTo(0.2)
        }
    }
    
    func update(_ detail: BillDetail) {
        nameLabel.text = detail.title
        detailLabel.text = detail.deail
    }
    
    // MARK: - lazy
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 174/255.0, green: 173/255.0, blue: 173/255.0, alpha: 0.5)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = lightTitleColor
        label.text = "类型"
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = defaultTitleColor
        label.text = "支出"
        return label
    }()
}

struct BillDetail {
    let title: String
    let deail: String
}
