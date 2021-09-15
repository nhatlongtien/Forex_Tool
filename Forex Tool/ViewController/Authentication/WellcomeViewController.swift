//
//  WellcomeViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit

class WellcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
extension WellcomeViewController:RegisterVCDelegate, LoginVCDelegate{
    func pushVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
