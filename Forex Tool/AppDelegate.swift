//
//  AppDelegate.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseFirestore
import GoogleSignIn
import FBSDKCoreKit
import PKHUD
import Localize_Swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let wellcomeVC = WellcomeViewController()
        let rootVC = wellcomeVC
        let navController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        //
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //
        FirebaseApp.configure()
        //Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //        GIDSignIn.sharedInstance().delegate = self
        //Facebook
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        //
        let user_uid = Constant.defaults.string(forKey: Constant.USER_ID)
        if user_uid != nil{
            print("User is signed in")
            setRootToDashboardVC()
        }else{
            //No user signed in
            print("No user signed in")
        }
        return true
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    //MARK: Helper Method
    func setRootToDashboardVC(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let targetVC = TabBarViewController()
        let navController = UINavigationController(rootViewController: targetVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}


