//
//  TCMonthView.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/17.
//

import UIKit
let _CELLID = "cell"

typealias MonthChangedBlock = (_ str: Date) -> Void
typealias DateSelectBlock = (_ dateItem: TCalendarDateItem) -> Void

class TCMonthView: UICollectionView {
    var datas: [TCalendarMonthItem] = []
    var monthCall : MonthChangedBlock?
    var dateCall : DateSelectBlock?

    var calendarViewLayout: TCalendarViewLayout = {
        let layout = TCalendarViewLayout.init()
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: calendarViewLayout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        dataSource = self
        delegate = self
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(TCalendarCollectionViewCell.self, forCellWithReuseIdentifier: _CELLID)
    }
}

extension TCMonthView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].dateList.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _CELLID, for: indexPath) as! TCalendarCollectionViewCell
        cell.item = datas[indexPath.section].dateList[indexPath.row]

        cell.updateUI()
        return cell
    }
    
}

extension TCMonthView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TCalendarCollectionViewCell else {
            return
        }
        cell.updateUI()

        if let dateCall = dateCall {
            dateCall(datas[indexPath.section].dateList[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TCalendarCollectionViewCell else {
            return
        }
        cell.updateUI()
    }
}

// MARK: - Scroll
extension TCMonthView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let monthCall = monthCall {
            let indexPaths = self.indexPathsForVisibleItems
            if let indexPath = indexPaths.first {
                let item = datas[indexPath.section]

                if let date = item.date {
                    monthCall(date)
                }
            }
        }
        
    }
}
