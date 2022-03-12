//
//  TCalendarViewLayout.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/17.
//

import UIKit

let maxNumberOfDaysInWeek = 7
let maxNumberOfRowsPerMonth = 6
let _itemW: CGFloat = ((KSCREENWIDTH ) / 7.0)
let _itemH: CGFloat = 50.0

class TCalendarViewLayout: UICollectionViewFlowLayout {
    
    var attriList: [UICollectionViewLayoutAttributes] = []
    override init() {
        super.init()
        itemSize = CGSize(width: _itemW, height: _itemH)
        scrollDirection = .horizontal
        sectionInset = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        
        let sectionCount = collectionView.numberOfSections
        for section in 0..<sectionCount {
            let itemCount = collectionView.numberOfItems(inSection: section)
            for i in 0..<itemCount {
                let indexPath = IndexPath(item: i, section: section)
                if let attri = layoutAttributesForItem(at: indexPath) {
                    attriList.append(attri)
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize(width: KSCREENWIDTH, height: 350)
        }
        
        return CGSize(width: CGFloat(collectionView.numberOfSections) * KSCREENWIDTH,
                      height: collectionView.frame.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let row = CGFloat(indexPath.row / maxNumberOfDaysInWeek)
        let column = CGFloat(indexPath.row % maxNumberOfDaysInWeek)
        
        let x = (column * _itemW) + (CGFloat(indexPath.section) * KSCREENWIDTH)
        let y = row * _itemH
        
        let attri = super.layoutAttributesForItem(at: indexPath)!
        attri.frame = CGRect(x: x, y: y, width: _itemW, height: _itemH)
        return attri
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        attriList
    }
}
