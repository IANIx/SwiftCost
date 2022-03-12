//
//  TNavigationController.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import UIKit

class TNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 进入 二级 控制器
        if viewControllers.count > 0 {
            // 是第一层, 就显示主标题, 否则, 都显示返回
            if viewControllers.count == 1 {
                title = viewControllers.first?.title ?? ""
                // push 时 隐藏tab
                viewController.hidesBottomBarWhenPushed = true
            }
            
            // 设置 返回按钮
            let backBtn: UIButton = UIButton(type: .custom)
            backBtn.setImage(UIImage.init(named: "back"), for: .normal)
            backBtn.addTarget(self, action: #selector(popButtonClick), for: .touchUpInside)
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popButtonClick() {
        popViewController(animated: true)
    }
}
