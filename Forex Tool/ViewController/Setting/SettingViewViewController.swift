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
        
    }
    //MARK: UI Event
    
    @IBAction func editProfileButtonWasPressed(_ sender: Any) {
    }
    @IBAction func settingButtonWasPressed(_ sender: Any) {
    }
    @IBAction func manageTransactionWasPressed(_ sender: Any) {
        let targetVC = ManageTransactionViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func economicNewsButtonWasPressed(_ sender: Any) {
        let targetVC = HomeNewsViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func economicCalenderWasPressed(_ sender: Any) {
        let targetVC = EconomicNewsViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func calculationToolButtonWasPressed(_ sender: Any) {
    }
    @IBAction func signOutButtonWasPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("Dang xuat thanh cong")
            HelperMethod.setRootToViewControler(targetVC: WellcomeViewController())
        }catch let error as NSError{
            print("Error signing out: %@", error)
            HelperMethod.showAlertWithMessage(message: "Error signing out: \(error.localizedDescription)")
        }
    }
    
}
