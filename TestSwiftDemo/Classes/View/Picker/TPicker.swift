//
//  TPicker.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/31.
//

import UIKit

typealias CancelBlock = () -> Void
typealias ConfirmBlock<T> = (_ result: T) -> Void

class TPicker: NSObject {
    static let shared = TPicker()

    override init() {
        print("TPicker init")
        super.init()
    }
    
    static public func showDatePicker(_ view: UIView? = nil,
                                      date: Date = Date(),
                                      confirm: ConfirmBlock<Date>? = nil,
                                      cancel: CancelBlock? = nil) {
        let datePicker = TDatePicker(date: date)
        datePicker.confirm = confirm
        datePicker.cancel = cancel
        datePicker.show(view)
    }
    
    deinit {
    }
}
