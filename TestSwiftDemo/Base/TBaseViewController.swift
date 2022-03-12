//
//  TBaseViewController.swift
//  TestSwiftDemo
//
//  Created by jqz on 2021/1/28.
//

import UIKit

class TBaseViewController: UIViewController {

    public var showBackItem = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupNav()
        setupSubviews()
        setupData()
    }
    
    func setupSubviews() {
    }
    
    func setupData() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) viewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) viewDidDisappear")
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    // MARK: - Navigation
    func setupNav() {
        if showBackItem {
            setupBackItem()
        }
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = mainColor
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupBackItem() {
        let backBtn: UIButton = UIButton(type: .custom)
        backBtn.setImage(UIImage.init(named: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }

}

extension TBaseViewController {
    
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
}
