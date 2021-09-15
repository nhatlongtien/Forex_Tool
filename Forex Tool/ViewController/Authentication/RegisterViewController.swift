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
    
    @IBOutlet weak var fullNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    //
    weak var delegate:RegisterVCDelegate?
    let authVM = AuthViewModel()
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModelCallBack()
    }
    
    
    @IBAction func registerButtonWasPressed(_ sender: Any) {
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
                        "uid": Constant.defaults.string(forKey: Constant.USER_ID)
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
