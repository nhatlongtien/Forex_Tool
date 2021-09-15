//
//  SettingViewViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit
import FirebaseAuth
class SettingViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        //
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("Dang xuat thanh cong")
        }catch let error as NSError{
            print("Error signing out: %@", error)
            HelperMethod.showAlertWithMessage(message: "Error signing out: \(error.localizedDescription)")
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
