//
//  TBillDetailBottomView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/6/16.
//

import UIKit

class TBillDetailBottomView: UIView {
    var editBlock: TVoidBlock?
    var deleteBlock: TVoidBlock?


    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self).offset(-bottomPadding)
        }

        let lineView = UIView()
        lineView.backgroundColor = bodyColor
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = bodyColor
        view.addSubview(lineView2)
        lineView2.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(0.5)
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
        }
        
        let editBtn = UIButton()
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitleColor(defaultTitleColor, for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        editBtn.addTarget(self, action: #selector(editDidClick), for: .touchUpInside)
        view.addSubview(editBtn)
        editBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(view)
            make.right.equalTo(lineView2)
        }
        
        let deleteBtn = UIButton()
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(defaultTitleColor, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        deleteBtn.addTarget(self, action: #selector(deleteDidClick), for: .touchUpInside)
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(view)
            make.left.equalTo(lineView2)
        }
    }
    
    
    @objc private func editDidClick() {
        if let block = editBlock {
            block()
        }
    }
    
    @objc private func deleteDidClick() {
        if let block = deleteBlock {
            block()
        }
    }
    
    func testBlock(block: @escaping TVoidBlock) {
        UIView.animate(withDuration: 5) {
            block()
        }
    }
}
