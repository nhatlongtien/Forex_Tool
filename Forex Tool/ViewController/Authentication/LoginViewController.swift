//
//  LoginViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit
import Firebase
import PKHUD
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
protocol LoginVCDelegate:class {
    func pushVC(vc:UIViewController)
}
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    //
    let authVM = AuthViewModel()
    weak var delegate: LoginVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelCallBack() //goi de show progressview
        //
        
        
    }

    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signInButtonWasPressed(_ sender: Any) {
        if !validate(){
            return
        }
        authVM.signIn(email: emailTf.text!, password: passwordTf.text!) { (result) in
            if result == true{
                self.dismiss(animated: false) {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let targetVC = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! UIViewController
                    let targetVC = TabBarViewController()
                    self.delegate?.pushVC(vc: targetVC)
                }
            }
        }
        
    }
    @IBAction func googleButtonWasPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    @IBAction func facebookButtonWasPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error{
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider
              .credential(withAccessToken: accessToken.tokenString)
            HUD.show(.systemActivity)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error{
                    HelperMethod.showAlertWithMessage(message: error.localizedDescription)
                    return
                }else{
                    //Sign in successfully
                    Constant.defaults.setValue(user?.user.uid, forKey: Constant.USER_ID)
                    //check user is existing or not, if existing let save the info to user table
                    
                    var ref: DocumentReference? = nil
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").whereField("uid", isEqualTo: user?.user.uid).getDocuments { [self] (result, error) in
                        if result?.documents.count == 0{
                            ref = db.collection("users").addDocument(data: [
                                "fullName" : user?.user.displayName,
                                "email": user?.user.email,
                                "phoneNumber":user?.user.phoneNumber,
                                "address":nil,
                                "uid": user?.user.uid
                            ], completion: { [self] (error) in
                                if let err = error{
                                    HelperMethod.showAlertWithMessage(message: err.localizedDescription
                                     ?? "")
                                }else{
                                    //luu thanh cong -> Di den dashboard
                                    HUD.hide()
                                    HelperMethod.setRootToDashboardVC()
                                }
                            })
                        }else{
                            HUD.hide()
                            HelperMethod.setRootToDashboardVC()
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func hiddenPassButtonWasPressed(_ sender: Any) {
    }
    //MARK: Helper Method
    func validate() -> Bool{
        if emailTf.text == nil || emailTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your email")
            return false
        }
        if emailTf.text?.isValadateEmail() == false{
            HelperMethod.showAlertWithMessage(message: "Your email is wrong formatter")
            return false
        }
        if passwordTf.text == nil || passwordTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your password")
            return false
        }
        if passwordTf.text?.isValadatePasswprd() == false{
            HelperMethod.showAlertWithMessage(message: "The password must contain at least one upper case, lower case, digits, special character and length from 8 – 20 characters")
            return false
        }
        return true
    }
    private func viewModelCallBack() {
        authVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        authVM.afterApiCall = {
            HUD.hide()
        }
    }
}



// Swift // // Extend the code sample from 6a. Add Facebook Login to Your Code // Add to your viewDidLoad method: loginButton.permissions = ["public_profile", "email"]
