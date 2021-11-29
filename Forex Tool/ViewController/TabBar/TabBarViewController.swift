//
//  TabBarViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit
import GoogleMobileAds
import SwiftUI
class TabBarViewController: UITabBarController {
    var dashboardVC:DashboardViewController?
    var transactionVC:HistoryTransactionViewController?
    var settingVC:ProfileViewController?
    var subviewController:[UIViewController] = []
    var customTabBar:CustomTabBar!
    var tabBarHeight:CGFloat = 55
    //
    private let banner:GADBannerView = {
        let banner = GADBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.adUnitID = "ca-app-pub-8162737912880549/6261272627"
        banner.load(GADRequest())
        banner.backgroundColor = .clear
        return banner
    }()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
        //
        banner.rootViewController = self
        self.view.addSubview(banner)
        banner.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        banner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        banner.bottomAnchor.constraint(equalTo: customTabBar.topAnchor).isActive = true
    }
    
    //MARK: Helper Method
    func loadTabBar(){
        // Tạo và load custom tab bar
        let tabbarItems:[TabItem] = [.caculationTool, .ecomomicNew, .home, .feed247, .profile]
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
