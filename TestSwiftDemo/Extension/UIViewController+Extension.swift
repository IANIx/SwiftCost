//
//  UIViewController+Extension.swift
//  JKSwiftExtension
//
//  Created by IronMan on 2020/9/24.
//

import UIKit

public extension UIViewController {

    /// 获取顶部控制器
    /// - Returns: VC
    static func topViewController() -> UIViewController? {
        
        guard let window = UIApplication.shared.currentWindow else {
            return nil
        }
        
        return top(window.rootViewController)
    }
    
    private static func top(_ rootVC: UIViewController? = nil) -> UIViewController? {
        guard let rootVC = rootVC else {
            return nil
        }
        
        if let presentedVC = rootVC.presentedViewController {
            return top(presentedVC)
        }
        
        if let nav = rootVC as? UINavigationController,
            let lastVC = nav.viewControllers.last {
            return top(lastVC)
        }
        
        if let tab = rootVC as? UITabBarController,
            let selectedVC = tab.selectedViewController {
            return top(selectedVC)
        }
        
        return rootVC
    }
}


