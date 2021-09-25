//
//  SettingViewViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit
import FirebaseAuth
import PKHUD
class SettingViewViewController: UIViewController {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    //
    let dashboardVM = DashboardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        //
        
        self.getUserInfoAndUpdateUI()
    }
    //MARK: UI Event
    
    @IBAction func editProfileButtonWasPressed(_ sender: Any) {
        let targetVC = EditProfileViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
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
        HUD.show(.systemActivity)
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("Dang xuat thanh cong")
            HUD.hide()
            HelperMethod.setRootToViewControler(targetVC: WellcomeViewController())
        }catch let error as NSError{
            print("Error signing out: %@", error)
            HUD.hide()
            HelperMethod.showAlertWithMessage(message: "Error signing out: \(error.localizedDescription)")
        }
    }
    //MARK: Helper Method
    func getUserInfoAndUpdateUI(){
        guard let uid = Constant.defaults.string(forKey: Constant.USER_ID) else {return}
        dashboardVM.getUserInfoByUserID(userID: uid) { (success, userInfo) in
            if success{
                self.userNameLbl.text = userInfo?.fullName?.capitalized
                let url = userInfo?.avatarImg
                if url != nil && url != ""{
                    self.avatarImg.kf.setImage(with: URL(string: url!))
                }else{
                    self.avatarImg.image = UIImage(named: "userIcon")
                }
                
            }
        }
    }
}
