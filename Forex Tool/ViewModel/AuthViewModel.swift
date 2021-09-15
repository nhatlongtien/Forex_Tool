//
//  AuthService.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 09/07/2021.
//

import Foundation
import Firebase
class AuthViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    //
    func createUser(email:String, password:String, completionHadler:@escaping(_ resulr:Bool) -> Void){
        beforeApiCall?()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil{
                //Dang ky thanh cong -> Dang nhap
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if error == nil{
                        //Dang nhap thanh cong
                        Constant.defaults.setValue(authResult?.user.uid, forKey: Constant.USER_ID)
                        completionHadler(true)
                    }else{
                        completionHadler(false)
                        HelperMethod.showAlertWithMessage(message: error?.localizedDescription ?? "")
                    }
                    self.afterApiCall?()
                }
            }else{
                completionHadler(false)
                HelperMethod.showAlertWithMessage(message: error?.localizedDescription ?? "")
            }
            self.afterApiCall?()
        }
    }
    func signIn(email:String, password:String, completionHandler:@escaping(_ result:Bool) -> Void){
        beforeApiCall?()
        Auth.auth().signIn(withEmail: email, password: password) { [self] (authResult, error) in
            if error == nil{
                
                Constant.defaults.setValue(authResult?.user.uid, forKey: Constant.USER_ID)
                completionHandler(true)
            }else{
                completionHandler(false)
                HelperMethod.showAlertWithMessage(message: error?.localizedDescription ?? "")
            }
            self.afterApiCall?()
        }
    }
    
}
