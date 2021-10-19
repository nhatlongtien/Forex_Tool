//
//  LoginViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit
import Firebase
import PKHUD
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit
protocol LoginVCDelegate:class {
    func pushVC(vc:UIViewController)
}
class LoginViewController: UIViewController {
    @IBOutlet weak var signInTitle: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var orSignInTitle: UILabel!
    @IBOutlet weak var dontAccountTitle: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    //
    let authVM = AuthViewModel()
    weak var delegate: LoginVCDelegate?
    //
    var isHiddenPassword = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //
        passwordTf.isSecureTextEntry = true
        //
        viewModelCallBack() //goi de show progressview
        //
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signInButtonWasPressed(_ sender: Any) {
        if !validate(){
            return
        }
        authVM.signIn(email: emailTf.text!, password: passwordTf.text!) { (result) in
            if result == true{
                self.dismiss(animated: false) {
                    let targetVC = TabBarViewController()
                    self.delegate?.pushVC(vc: targetVC)
                }
            }
        }
        
    }
    @IBAction func googleButtonWasPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    @IBAction func facebookButtonWasPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error{
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider
                .credential(withAccessToken: accessToken.tokenString)
            HUD.show(.systemActivity)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error{
                    HelperMethod.showAlertWithMessage(message: error.localizedDescription)
                    return
                }else{
                    //Sign in successfully
                    Constant.defaults.setValue(user?.user.uid, forKey: Constant.USER_ID)
                    //check user is existing or not, if existing let save the info to user table
                    self.checkUserExit(userUid: (user?.user.uid)!) { (isExit) in
                        if isExit == true{
                            //User exit -> go to dashboard
                            HelperMethod.setRootToDashboardVC()
                        }else{
                            //User is not exit -> go to add info popup
                            let targetVC = AddPersonalInfoPoupViewController()
                            targetVC.modalPresentationStyle = .custom
                            targetVC.email = user?.user.email
                            targetVC.fullName = user?.user.displayName
                            targetVC.userUid = user?.user.uid
                            targetVC.methodLogin = MethodLoginType.facebook.rawValue
                            self.present(targetVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func appleLoginButtonWasPressed(_ sender: Any) {
        
        startSignInWithAppleFlow()
    }
    @IBAction func hiddenPassButtonWasPressed(_ sender: Any) {
        if isHiddenPassword == true{
            passwordTf.isSecureTextEntry = false
            isHiddenPassword = false
        }else{
            passwordTf.isSecureTextEntry = true
            isHiddenPassword = true
        }
    }
    @IBAction func createAccountButtonWasPressed(_ sender: Any) {
        let targetVC = RegisterViewController()
        self.present(targetVC, animated: true, completion: nil)
    }
    //MARK: Helper Method
    func setupUI(){
        signInTitle.text = "Sign In".localized()
        signInButton.setTitle("Sign In".localized(), for: .normal)
        orSignInTitle.text = "or Sign In with".localized()
        dontAccountTitle.text = "Don't have an account?".localized()
        createAccountButton.setTitle("Create an account".localized(), for: .normal)
        emailTf.placeholder = "Email".localized()
        passwordTf.placeholder = "Password".localized()
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
        return true
    }
    func checkUserExit(userUid:String, completionHandler:@escaping(_ isExit:Bool) -> Void){
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        HUD.show(.systemActivity)
        let docRef = db.collection("users").whereField("uid", isEqualTo: userUid).getDocuments { [self] (result, error) in
            if result?.documents.count == 0{
                //Khong ton tai
                completionHandler(false)
            }else{
                HUD.hide()
                //HelperMethod.setRootToDashboardVC()
                completionHandler(true)
            }
        }
    }
    private func viewModelCallBack() {
        authVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        authVM.afterApiCall = {
            HUD.hide()
        }
    }
    
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
//MARK:
extension LoginViewController:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Dang nhap bang credential
        HUD.show(.systemActivity)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let err = error{
                HelperMethod.showAlertWithMessage(message: err.localizedDescription ?? "")
            }else{
                //Dang nhap thanh cong
                Constant.defaults.setValue(authResult?.user.uid, forKey: Constant.USER_ID)
                //Check user is exsit
                
                self.checkUserExit(userUid: (authResult?.user.uid)!) { (isExit) in
                    if isExit == true{
                        //User exit -> go to dashboard
                        HelperMethod.setRootToDashboardVC()
                    }else{
                        //User is not exit -> go to add info popup
                        let targetVC = AddPersonalInfoPoupViewController()
                        targetVC.modalPresentationStyle = .custom
                        targetVC.email = user.profile.email
                        targetVC.fullName = user.profile.name
                        targetVC.userUid = authResult?.user.uid
                        targetVC.methodLogin = MethodLoginType.gmail.rawValue
                        self.present(targetVC, animated: true, completion: nil)
                    }
                }
            }
        }
        print("User email: \(user.profile.email ?? "No Email")")
    }
}
extension LoginViewController:ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            HUD.show(.systemActivity)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? "Anonymous"
                let phoneNumber = user.phoneNumber
                guard let uid = Auth.auth().currentUser?.uid else { return }
                print(uid)
                //Sign in successfully
                Constant.defaults.setValue(uid, forKey: Constant.USER_ID)
                //check user is existing or not, if existing let save the info to user table
                self.checkUserExit(userUid: uid) { (isExit) in
                    if isExit == true{
                        //User exit -> go to dashboard
                        HelperMethod.setRootToDashboardVC()
                    }else{
                        //User is not exit -> go to add info popup
//                        let targetVC = AddPersonalInfoPoupViewController()
//                        targetVC.modalPresentationStyle = .custom
//                        targetVC.email = email
//                        targetVC.fullName = displayName
//                        targetVC.userUid = uid
//                        targetVC.methodLogin = MethodLoginType.apple.rawValue
//                        self.present(targetVC, animated: true, completion: nil)
                        
                        var ref: DocumentReference? = nil
                        let db = Firestore.firestore()
                        HUD.show(.systemActivity)
                        ref = db.collection("users").addDocument(data: [
                            "fullName" : displayName,
                            "email": email,
                            "phoneNumber":phoneNumber,
                            "address":nil,
                            "uid": uid,
                            "methodLogin": MethodLoginType.apple.rawValue,
                            "password": nil,
                            "avatarImg": nil
                        ], completion: { [self] (error) in
                            if let err = error{
                                HUD.hide()
                                HelperMethod.showAlertWithMessage(message: err.localizedDescription
                                                                    ?? "")
                            }else{
                                //luu thanh cong -> Di den dashboard
                                HUD.hide()
                                HelperMethod.setRootToDashboardVC()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
