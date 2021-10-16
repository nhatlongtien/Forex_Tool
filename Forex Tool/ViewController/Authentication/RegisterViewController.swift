//
//  SignInViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import PKHUD
protocol RegisterVCDelegate:class{
    func pushViewController(vc:UIViewController)
}
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var fullNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var repeatpasswordTf: UITextField!
    //
    var isHidenPassword = true
    var isHidenRepeatPassword = true
    //
    weak var delegate:RegisterVCDelegate?
    let authVM = AuthViewModel()
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModelCallBack()
        //
        passwordTf.isSecureTextEntry = true
        repeatpasswordTf.isSecureTextEntry = true
    }
    
    
    @IBAction func registerButtonWasPressed(_ sender: Any) {
        self.view.endEditing(true)
        if !validate(){
            return
        }
        authVM.createUser(email: emailTf.text!, password: passwordTf.text!) { (result) in
            if result == true{
                self.dismiss(animated: false) { [self] in
                    //Save user info into firebase
                    
                    ref = db.collection("users").addDocument(data: [
                        "fullName" : fullNameTf.text!,
                        "email": emailTf.text!,
                        "phoneNumber":phoneTf.text!,
                        "address":addressTf.text!,
                        "uid": Constant.defaults.string(forKey: Constant.USER_ID),
                        "methodLogin": MethodLoginType.email_password.rawValue,
                        "avatarImg": nil,
                        "password":nil
                    ], completion: { (error) in
                        if let err = error {
                            HelperMethod.showAlertWithMessage(message: "Error adding document: \(err)")
                            
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    })
                    
                    let targetVC = TabBarViewController()
                    self.delegate?.pushViewController(vc: targetVC)
                }
            }
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hiddenPasswordButtonWasPressed(_ sender: Any) {
        if isHidenPassword == true{
            passwordTf.isSecureTextEntry = false
            isHidenPassword = false
        }else{
            passwordTf.isSecureTextEntry = true
            isHidenPassword = true
        }
    }
    @IBAction func hiddenRepeatPasswordButtonWasPressed(_ sender: Any) {
        if isHidenRepeatPassword == true{
            repeatpasswordTf.isSecureTextEntry = false
            isHidenRepeatPassword = false
        }else{
            repeatpasswordTf.isSecureTextEntry = true
            isHidenRepeatPassword = true
        }
    }
    //MARK: Helper Method
    func setupUI(){
        registerButton.setTitle("Register".localized(), for: .normal)
        fullNameTf.placeholder = "Full Name".localized()
        emailTf.placeholder = "Email".localized()
        passwordTf.placeholder = "Password".localized()
        repeatpasswordTf.placeholder = "Repeat Password".localized()
        phoneTf.placeholder = "Phone Number".localized()
        addressTf.placeholder = "Address".localized()
    }
    func validate() -> Bool{
        if emailTf.text == nil || emailTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your email".localized())
            return false
        }
        if emailTf.text?.isValadateEmail() == false{
            HelperMethod.showAlertWithMessage(message: "Your email is wrong format".localized())
            return false
        }
        if passwordTf.text == nil || passwordTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your password".localized())
            return false
        }
        if passwordTf.text?.isValadatePasswprd() == false{
            HelperMethod.showAlertWithMessage(message: "The password must contain at least one upper case, lower case, digits, special character and length from 8 – 20 characters".localized())
            return false
        }
        if repeatpasswordTf.text == nil || repeatpasswordTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your repeat password")
            return false
        }
        if repeatpasswordTf.text != passwordTf.text{
            HelperMethod.showAlertWithMessage(message: "Your password and repeat password not match!")
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
