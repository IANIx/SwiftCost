//
//  TMineViewController.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import UIKit

class TMineViewController: TBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func setupSubviews() {
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        button.backgroundColor = mainColor
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func btnClick() {
        if let window = UIApplication.shared.currentWindow {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.green
            window.rootViewController = vc
        }
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
