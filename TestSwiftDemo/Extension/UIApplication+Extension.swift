//
//  UIApplication+Extension.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/31.
//

import UIKit

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}

extension TBaseViewController {
    
    @objc func t_viewWillAppear(_ animated: Bool) {
        self.t_viewWillAppear(animated)
        print("viewWillAppear -- > %p", self)
    }

}
