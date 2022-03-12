//
//  TUtils.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import Foundation
import UIKit

/// FECE4E
let mainColor = UIColor.hexStringColor(hexString: "#FFDA45")
let lightColor = UIColor.hexStringColor(hexString: "#F5F5F5")
let bodyColor = UIColor.hexStringColor(hexString: "#DFDFDF")
let defaultTitleColor = UIColor.hexStringColor(hexString: "#333333")

let lightTitleColor = UIColor.init(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1)
let tabbarTitleColor = UIColor.init(red: 75/255.0, green: 56/255.0, blue: 31/255.0, alpha: 1)
let createBodyColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)


typealias TVoidBlock = () -> Void
typealias TDataBlock<T> = (_ data: T) -> Void

/// 判断是否为刘海屏幕
@available(iOS 11.0, *)
func iPhoneXSeries() -> Bool{
    let insets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
    return insets.bottom > CGFloat(0) ? true : false
}

/// safeArea
let topPadding: CGFloat = UIApplication.shared.currentWindow?.safeAreaInsets.top ?? 0.0
let bottomPadding: CGFloat = UIApplication.shared.currentWindow?.safeAreaInsets.bottom ?? 0.0

/// 导航栏高度
let NaviHeight = iPhoneXSeries() ? 88 : 64
/// x 系列标签栏 底部横岗的高度
let AdaptTabHeight = iPhoneXSeries() ? 34 : 0
/// 标签栏高度
let TabBarHeight = iPhoneXSeries() ? 83 : 49

// MARK: 屏幕尺寸相关
let KSCREENBOUNDS = UIScreen.main.bounds
let KSCREENWIDTH = KSCREENBOUNDS.width
let KSCREENHEIGHT = KSCREENBOUNDS.height

