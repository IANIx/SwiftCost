//
//  TCreateBodyView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/10.
//

import UIKit
import SnapKit

// 计算图片的宽高
private let itemWH: CGFloat = 50.0
// 图片与两侧的举例
private let bothSides: CGFloat = 30
// 图片与图片间的举例
private let space: CGFloat = (KSCREENWIDTH - (itemWH * 4) - (bothSides * 2))/3

private let CREATECELLID: String = "CREATECELL_ID"

typealias TCreateCategoryBlock = (_ category: TCategoryModel?) -> Void

class TCreateBodyView: UIView {
    
    var model: THomeBillModel? {
        didSet {
            setupData()
        }
    }
    
    var categoryBlock :TCreateCategoryBlock?
    
    
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
            make.edges.equalTo(self)
        }
        
        scrollView.contentSize = CGSize.init(width: KSCREENWIDTH * 2,
                                             height: KSCREENHEIGHT - CGFloat(NaviHeight) - CGFloat(AdaptTabHeight))
        scrollView.addSubview(content1)
        content1.snp.makeConstraints { (make) in
            make.size.equalTo(scrollView)
            make.left.top.width.equalTo(scrollView)
        }
        scrollView.addSubview(content2)
        content2.snp.makeConstraints { (make) in
            make.size.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.left.equalTo(scrollView).offset(KSCREENWIDTH)
        }
    }
    
    private func setupData() {
        if let model = self.model {
            scrollViewOffset(model.type - 1)
            
            if model.type == 1 {
                let index = TCategoryViewModel.shared.expensesList.firstIndex { (category) -> Bool in
                    model.categoryId == category.category_id
                } ?? 0
                content1.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .left)

            } else {
                let index = TCategoryViewModel.shared.incomeList.firstIndex { (category) -> Bool in
                    model.categoryId == category.category_id
                } ?? 0
                content2.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .left)
            }
        }
    }

    func scrollViewOffset(_ index: Int) {
        if index == 0 {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint.init(x: KSCREENWIDTH, y: 0), animated: true)
        }
    }
    
    // MARK: - lazy
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.isPagingEnabled = true
        return view
    }()
    
    private lazy var content1: TCreateBodyContentView = {
        let view = TCreateBodyContentView(frame: CGRect.zero)
        view.data = TCategoryViewModel.shared.expensesList
        view.categoryBlock = { [weak self] category in
            self?.categoryBlock?(category)
        }
        return view
    }()
    
    private lazy var content2: TCreateBodyContentView = {
        let view = TCreateBodyContentView(frame: CGRect.zero)
        view.data = TCategoryViewModel.shared.incomeList
        view.categoryBlock = { [weak self] category in
            self?.categoryBlock?(category)
        }
        return view
    }()
    
}


class TCreateBodyContentView: UICollectionView {
    var categoryBlock :TCreateCategoryBlock?

    var data: [TCategoryModel]? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 自定义的layout
        let picLayout = UICollectionViewFlowLayout()
        picLayout.itemSize = CGSize(width: itemWH, height: itemWH + 30)
        picLayout.minimumInteritemSpacing = space - 0.1
        picLayout.sectionInset = UIEdgeInsets.init(top: 0, left: bothSides, bottom: 0, right: bothSides)
        super.init(frame: frame, collectionViewLayout: picLayout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        dataSource = self
        delegate = self
        register(TCreateCollectionViewCell.self, forCellWithReuseIdentifier: CREATECELLID)
    }
}

extension TCreateBodyContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CREATECELLID, for: indexPath) as! TCreateCollectionViewCell
        cell.data = data?[indexPath.row]
        return cell
    }
    
}

extension TCreateBodyContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryBlock?(data?[indexPath.row])

        guard let cell = collectionView.cellForItem(at: indexPath) as? TCreateCollectionViewCell else {
            return
        }
        cell.updateUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TCreateCollectionViewCell else {
            return
        }
        cell.updateUI()
    }
}
