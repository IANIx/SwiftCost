//
//  TTabBarViewController.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import UIKit

class TTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        addChild(THomeViewController(), title: "明细", imageName: "tabbar_home")
        addChild(TChartViewController(), title: "图表", imageName: "tabbar_chart")
        addChild(TMineViewController(), title: "我的", imageName: "tabbar_mine")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TTabBarViewController {
    
    private func addChild(_ childController: UIViewController, title: String, imageName: String) {
        
        childController.title = title
        
        if #available(tvOS 13.0, *) {
            self.tabBar.tintColor = tabbarTitleColor
        } else {
            childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: tabbarTitleColor], for: UIControl.State.selected)
        }

        
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        addChild(TNavigationController(rootViewController: childController))
    }
    
    private func setupTabbar() {
        tabBar.isTranslucent = false
       
    }
}

