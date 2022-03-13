//
//  WellcomeNewViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 24/12/2021.
//

import UIKit

class WellcomeNewViewController: BaseViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInLineView: UIView!
    @IBOutlet weak var registerLineView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    //
    let loginVC = LoginViewController()
    let registerVC = RegisterViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        signInButton.setTitle("Sign In".localized(), for: .normal)
        registerButton.setTitle("Register".localized(), for: .normal)
        addLoginVC()
    }
    
    @IBAction func signInButtonWasPressed(_ sender: Any) {
        signInButton.titleLabel?.textColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
        registerButton.titleLabel?.textColor = .lightGray
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.signInLineView.isHidden = false
            self.registerLineView.isHidden = true
        }, completion: nil)
        removeRegisterVC()
        addLoginVC()
        
    }
    @IBAction func registerButtonWasPressed(_ sender: Any) {
        registerButton.titleLabel?.textColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
        signInButton.titleLabel?.textColor = .lightGray
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.signInLineView.isHidden = true
            self.registerLineView.isHidden = false
        }, completion: nil)
        removeLoginVC()
        addRegisterVC()
    }
    //MARK: Helper Method
    private func addLoginVC(){
        addChild(loginVC)
        containerView.addSubview(loginVC.view)
        loginVC.didMove(toParent: self)
        //
        loginVC.view.translatesAutoresizingMaskIntoConstraints = false
        loginVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        loginVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        loginVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        loginVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
    }
    private func addRegisterVC(){
        addChild(registerVC)
        containerView.addSubview(registerVC.view)
        registerVC.didMove(toParent: self)
        //
        registerVC.view.translatesAutoresizingMaskIntoConstraints = false
        registerVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        registerVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        registerVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        registerVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
    }
    private func removeLoginVC(){
        if loginVC != nil{
            if self.containerView.subviews.contains(loginVC.view){
                loginVC.view.removeFromSuperview()
            }
        }
    }
    private func removeRegisterVC(){
        if registerVC != nil{
            if self.containerView.subviews.contains(registerVC.view){
                registerVC.view.removeFromSuperview()
            }
        }
    }
}
