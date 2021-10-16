//
//  WellcomeViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit

class WellcomeViewController: UIViewController {

    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func loginButtonWasPressed(_ sender: Any) {
        let targetVC = LoginViewController()
        targetVC.modalPresentationStyle = .custom
        targetVC.delegate = self
        self.present(targetVC, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonWasPressed(_ sender: Any) {
        let targetVC = RegisterViewController()
        targetVC.modalPresentationStyle = .custom
        targetVC.delegate = self
        self.present(targetVC, animated: true, completion: nil)
        
    }
    //MARK: Helper Method
    func setupUI(){
        welcomeTitle.text = "Let's get started!".localized()
        subTitle.text = "Please login or register to use the services of Forex Tool!".localized()
        loginButton.setTitle("Login".localized(), for: .normal)
        registerButton.setTitle("Register".localized(), for: .normal)
    }
    
}
extension WellcomeViewController:RegisterVCDelegate, LoginVCDelegate{
    func pushVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
