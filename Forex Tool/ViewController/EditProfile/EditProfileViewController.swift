//
//  EditProfileViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 24/09/2021.
//

import UIKit
import FirebaseStorage
import PKHUD
class EditProfileViewController: BaseViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameTf: UITextField!
    @IBOutlet weak var phoneNumberTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var DOBTf: UITextField!
    //
    var isChangeAvatar:Bool = false
    var dataImage:Data?
    var userInfo:UserModel?
    //
    var dashboardVM = DashboardViewModel()
    var editProfileVM = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.title = "Edit Profile"
        //
        self.viewModelCallBack()
        //
        self.avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatarImage))
        self.avatarImageView.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getUserInfoAndUpdateUI()
    }
    //MARK: UI Event
    @IBAction func updateButtonWasPressed(_ sender: Any) {
        guard let documentID = userInfo?.documentID else {return}
        if !validate(){
            return
        }
        if dataImage != nil{
            //upload image -> change info
            editProfileVM.uploadImageToFrirebasestore(dataImage: dataImage!) { [self] (success, ulrImage) in
                if success{
                    editProfileVM.updateUserByDocumentID(documentID: documentID, fullName: fullNameTf.text, phoneNumber: phoneNumberTf.text, address: addressTf.text, dateOfBirth: DOBTf.text, avatarUrl: ulrImage) { (success) in
                        if success{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }else{
            //update without avatar
            editProfileVM.updateUserByDocumentIDWithoutImage(documentID: documentID, fullName: fullNameTf.text, phoneNumber: phoneNumberTf.text, address: addressTf.text, dateOfBirth: DOBTf.text) { success in
                if success{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func chooseDateOfBirthButtonWasPressed(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
        }
        let alert = UIAlertController(title: "Choose your DOB", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width - 105, height: 180)
        let selectButton = UIAlertAction(title: "Choose", style: .default) { (action) in
            print(datePicker.date)
            self.DOBTf.text = datePicker.date.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(selectButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: Helper Method
    @objc func didTapAvatarImage(){
        self.setupPhotoPicker()
    }
    func getUserInfoAndUpdateUI(){
        guard let uid = Constant.defaults.string(forKey: Constant.USER_ID) else {return}
        dashboardVM.getUserInfoByUserID(userID: uid) { (success, userInfo) in
            if success{
                self.userInfo = userInfo
                //
                self.fullNameTf.text = userInfo?.fullName?.capitalized
                self.phoneNumberTf.text = userInfo?.phoneNumber
                self.addressTf.text = userInfo?.address
                let urlImage = userInfo?.avatarImg
                if urlImage != nil && urlImage != ""{
                    self.avatarImageView.kf.setImage(with: URL(string: urlImage!))
                }else{
                    self.avatarImageView.image = UIImage(named: "userIcon")
                }
                if userInfo?.dateOfBirth != nil && userInfo?.dateOfBirth != ""{
                    let date = userInfo?.dateOfBirth?.formartDate(inputFormat: DateformatterType.DD_MM_YYYY_Slash.rawValue)
                    self.DOBTf.text = date?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue)
                }
            }
        }
    }
    func validate() -> Bool{
        if fullNameTf.text == nil || fullNameTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your full name")
            return false
        }
        if fullNameTf.text?.isValidateFullName() == false{
            HelperMethod.showAlertWithMessage(message: "Your full name is wrong format")
            return false
        }
        if phoneNumberTf.text == nil || phoneNumberTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your phone number.")
            return false
        }
        if phoneNumberTf.text?.isValidatePhoneNumber() == false{
            HelperMethod.showAlertWithMessage(message: "Your phone number is wrong format")
            return false
        }
        if addressTf.text == nil || addressTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your address")
            return false
        }
        if DOBTf.text == nil || DOBTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your DOB")
            return false
        }
        return true
    }
    //
    func viewModelCallBack(){
        editProfileVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        editProfileVM.afterApiCall = {
            HUD.hide()
        }
    }
}
//MARK:
extension EditProfileViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicker = info[.originalImage] as! UIImage
        self.avatarImageView.image = imagePicker
        //
        self.dataImage = imagePicker.jpegData(compressionQuality: 0.4)
        self.dismiss(animated: true, completion: nil)
    }
}
