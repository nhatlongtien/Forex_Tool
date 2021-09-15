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
        GIDSignIn.sharedInstance().delegate = self
        //Facebook
        
        ApplicationDelegate.shared.application(
                   application,
                   didFinishLaunchingWithOptions: launchOptions
               )
        // set root
        if Auth.auth().currentUser != nil{
            //User is signed in
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
extension AppDelegate: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                     accessToken: authentication.accessToken)
      // Dang nhap bang credential
        HUD.show(.systemActivity)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let err = error{
                HelperMethod.showAlertWithMessage(message: err.localizedDescription ?? "")
            }else{
                //Dang nhap thanh cong -> check ton tai hay khoong -> Luu thong tin nguoi dung len firebase
                Constant.defaults.setValue(authResult?.user.uid, forKey: Constant.USER_ID)
                //Check user is exsit
                
                var ref: DocumentReference? = nil
                let db = Firestore.firestore()
                let docRef = db.collection("users").whereField("uid", isEqualTo: authResult?.user.uid).getDocuments { [self] (result, error) in
                    if result?.documents.count == 0{
                        ref = db.collection("users").addDocument(data: [
                            "fullName" : user.profile.name,
                            "email": user.profile.email,
                            "phoneNumber":nil,
                            "address":nil,
                            "uid": authResult?.user.uid
                        ], completion: { [self] (error) in
                            if let err = error{
                                HelperMethod.showAlertWithMessage(message: err.localizedDescription
                                 ?? "")
                            }else{
                                //luu thanh cong -> Di den dashboard
                                HUD.hide()
                                setRootToDashboardVC()
                            }
                        })
                    }else{
                        HUD.hide()
                        setRootToDashboardVC()
                    }
                }
            }
        }
        print("User email: \(user.profile.email ?? "No Email")")
    }


    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}

