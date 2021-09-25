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
    var settingVC:ProfileViewController?
    var subviewController:[UIViewController] = []
    //
    var customTabBar:CustomTabBar!
    var tabBarHeight:CGFloat = 67.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
        //
//        self.tabBarController?.navigationController?.navigationBar.isHidden = true
//        //
//        self.view.backgroundColor = .white
//        dashboardVC = DashboardViewController()
//        transactionVC = HistoryTransactionViewController()
//        settingVC = SettingViewViewController()
//
//        subviewController.append(transactionVC!)
//        subviewController.append(dashboardVC!)
//        subviewController.append(settingVC!)
//
//        transactionVC?.tabBarItem = UITabBarItem(title: "Transaction", image: UIImage(named: "historyIcon"), selectedImage: UIImage(named: "historySelectedIcon"))
//        transactionVC?.tabBarItem.tag = 0
//        dashboardVC?.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), selectedImage: UIImage(named: "homeSelectedIcon"))
//        dashboardVC?.tabBarItem.tag = 1
//        settingVC?.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "settingIcon"), selectedImage: UIImage(named: "settingSelectedIcon"))
//        settingVC?.tabBarItem.tag = 2
//
//        self.setViewControllers(subviewController, animated: true)
//        self.selectedIndex = 1
//        self.selectedViewController = dashboardVC
    }
    
    //MARK: Helper Method
    func loadTabBar(){
        // Tạo và load custom tab bar
        let tabbarItems:[TabItem] = [.caculationTool, .ecomomicNew, .home, .manageTransaction, .profile]
        setupCustomTabMenu(tabbarItems) { (viewControllers) in
            self.viewControllers = viewControllers
        }
        selectedIndex = 2 // Set default selected index thành item Home
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion:@escaping([UIViewController]) -> Void){
        // Handle custom tab bar và các attach touch event listener
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        // Ẩn tab bar mặc định của hệ thống đi
        self.tabBar.isHidden = true
        // Khởi tạo custom tab bar
        customTabBar = CustomTabBar(menuItems: menuItems, frame: frame)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab(tab:)
        view.addSubview(customTabBar)
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1)
        
        // Auto layout cho custom tab bar
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        // Thêm các view controller tương ứng
        menuItems.forEach({
            controllers.append($0.viewController)
        })
        view.layoutIfNeeded()
        completion(controllers)
    }
    func changeTab(tab:Int){
        self.selectedIndex = tab
    }
}
