//
//  TabBarViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    var dashboardVC:DashboardViewController?
    var transactionVC:HistoryTransactionViewController?
    var settingVC:SettingViewViewController?
    var subviewController:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        //
        self.view.backgroundColor = .white
        dashboardVC = DashboardViewController()
        transactionVC = HistoryTransactionViewController()
        settingVC = SettingViewViewController()
        
        subviewController.append(transactionVC!)
        subviewController.append(dashboardVC!)
        subviewController.append(settingVC!)
        
        transactionVC?.tabBarItem = UITabBarItem(title: "Transaction", image: UIImage(named: "historyIcon"), selectedImage: UIImage(named: "historySelectedIcon"))
        transactionVC?.tabBarItem.tag = 0
        dashboardVC?.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), selectedImage: UIImage(named: "homeSelectedIcon"))
        dashboardVC?.tabBarItem.tag = 1
        settingVC?.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "settingIcon"), selectedImage: UIImage(named: "settingSelectedIcon"))
        settingVC?.tabBarItem.tag = 2
        
        self.setViewControllers(subviewController, animated: true)
        self.selectedIndex = 1
        self.selectedViewController = dashboardVC
    }


    

}
