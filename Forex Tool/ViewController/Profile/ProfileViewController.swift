//
//  SettingViewViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit
import FirebaseAuth
import PKHUD
import Lightbox
class ProfileViewController: UIViewController {
    //
    @IBOutlet weak var personalTitle: UILabel!
    @IBOutlet weak var editProfileTitle: UILabel!
    @IBOutlet weak var editProfileDetailTitle: UILabel!
    @IBOutlet weak var setingTitle: UILabel!
    @IBOutlet weak var setingDetailTitle: UILabel!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var manageTransactionTitle: UILabel!
    @IBOutlet weak var manageTransactionDetailTitle: UILabel!
    @IBOutlet weak var economicNewsTitle: UILabel!
    @IBOutlet weak var economicNewsDetailTitle: UILabel!
    @IBOutlet weak var economicCalendarTitle: UILabel!
    @IBOutlet weak var economicCalendarDetailTitle: UILabel!
    @IBOutlet weak var calculationToolTitle: UILabel!
    @IBOutlet weak var calculationToolDetailTitle: UILabel!
    @IBOutlet weak var signOutTitle: UILabel!
    @IBOutlet weak var analysisTitle: UILabel!
    @IBOutlet weak var analysisDetailTitle: UILabel!
    @IBOutlet weak var marketTitle: UILabel!
    @IBOutlet weak var marketDetailTitle: UILabel!
    
    //
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    //
    let dashboardVM = DashboardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        Constant.isInTabBarControll = false
        //
        
        self.getUserInfoAndUpdateUI()
        //
        avatarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAvatarImg)))
        avatarImg.isUserInteractionEnabled = true
    }
    //MARK: UI Event
    
    @IBAction func editProfileButtonWasPressed(_ sender: Any) {
        let targetVC = EditProfileViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func settingButtonWasPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    @IBAction func manageTransactionWasPressed(_ sender: Any) {
        let targetVC = ManageTransactionViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func economicNewsButtonWasPressed(_ sender: Any) {
        let targetVC = HomeNewsViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func economicCalenderWasPressed(_ sender: Any) {
        let targetVC = EconomicCalendarViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func AnalysisButtonWasPressed(_ sender: Any) {
        let targetVC = AnalysisViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func marketButtonWasPressed(_ sender: Any) {
        let targetVC = HomeMarketViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func calculationToolButtonWasPressed(_ sender: Any) {
        let targetVC = HomeCalculationViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func signOutButtonWasPressed(_ sender: Any) {
        HUD.show(.systemActivity)
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("Dang xuat thanh cong")
            Constant.defaults.setValue(nil, forKey: Constant.USER_ID)
            HUD.hide()
            HelperMethod.setRootToViewControler(targetVC: WellcomeViewController())
        }catch let error as NSError{
            print("Error signing out: %@", error)
            HUD.hide()
            HelperMethod.showAlertWithMessage(message: "Error signing out: \(error.localizedDescription)")
        }
    }
    //MARK: Helper Method
    @objc func handleTapAvatarImg(){
        let images = [LightboxImage(image: avatarImg.image!)]
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        // Use dynamic background.
        controller.dynamicBackground = true
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
    func setupUI(){
        personalTitle.text = "Personal".localized()
        editProfileTitle.text = "Edit Profile".localized()
        editProfileDetailTitle.text = "Make Change Your Profile".localized()
        setingTitle.text = "Setting".localized()
        setingDetailTitle.text = "Change your application setting".localized()
        featureTitle.text = "Frature".localized()
        manageTransactionTitle.text = "Manage Transaction".localized()
        manageTransactionDetailTitle.text = "View all your transactions".localized()
        economicNewsTitle.text = "Economic News".localized()
        economicNewsDetailTitle.text = "Read economic news".localized()
        economicCalendarTitle.text = "Economic Calendar".localized()
        economicCalendarDetailTitle.text = "Update economic calendar".localized()
        calculationToolTitle.text = "Calculation Forex Tool".localized()
        calculationToolDetailTitle.text = "Calculation your transaction".localized()
        signOutTitle.text = "Sign Out".localized()
        marketTitle.text = "Market".localized()
        analysisTitle.text = "Analysis & Opinion".localized()
        analysisDetailTitle.text = "View all anlysis and opinion".localized()
        marketDetailTitle.text = "View info global market".localized()
    }
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
