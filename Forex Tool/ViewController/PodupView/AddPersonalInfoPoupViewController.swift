//
//  AddPersonalInfoPoupViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 20/09/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import PKHUD
class AddPersonalInfoPoupViewController: BaseViewController {
    
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var dateOfBirthTf: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    //
    var email:String? = ""
    var fullName:String? = ""
    var userUid:String? = ""
    var methodLogin:String = ""
    var imageData:Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        phoneTf.keyboardType = .numberPad
        dateOfBirthTf.isUserInteractionEnabled = false
        //
        self.avatarImageView.isUserInteractionEnabled = true
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        self.avatarImageView.addGestureRecognizer(tagGesture)
    }
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        //Validation input -> goi func checkAndUpdateInfoForUser
        if !validate(){
            return
        }
        if let imageData = imageData{
            uploadImageToFrirebasestore(dataImage: imageData) { [self] (success, urlImageStr) in
                if success{ //Call func checkAndUpdateInfoForUser to update info
                    checkAndUpdateInfoForUser(fullname: self.fullName!, email: self.email, phoneNumber: phoneTf.text!, address: addressTf.text!, avatarImg: urlImageStr)
                }
            }
        }else{
            checkAndUpdateInfoForUser(fullname: self.fullName!, email: self.email, phoneNumber: phoneTf.text!, address: addressTf.text!, avatarImg: nil)
        }
        
    }
    @available(iOS 13.4, *)
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
            self.dateOfBirthTf.text = datePicker.date.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(selectButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Helper Method
    func checkAndUpdateInfoForUser(fullname:String, email:String?, phoneNumber:String, address:String, avatarImg:String?){
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        HUD.show(.systemActivity)
        ref = db.collection("users").addDocument(data: [
            "fullName" : fullname,
            "email": email,
            "phoneNumber":phoneNumber,
            "address":address,
            "uid": self.userUid,
            "methodLogin": self.methodLogin,
            "password": nil,
            "avatarImg": avatarImg
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
    //
    func uploadImageToFrirebasestore(dataImage:Data, completionHandeler:@escaping(_ result:Bool, _ imageUrl:String?) -> Void){
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        let ramdomName = "\(UUID().uuidString).jpg"
        let ref = storageRef.child("images/\(ramdomName)")
        // Upload the file to the path
        let uploadTask = ref.putData(dataImage, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                completionHandeler(false, nil)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandeler(false, nil)
                    return
                }
                let strUrlImage = downloadURL.absoluteString
                completionHandeler(true, strUrlImage)
            }
        }
    }
    //
    func validate() -> Bool{
        if phoneTf.text == nil || phoneTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your phone number.")
            return false
        }
        if phoneTf.text?.isValidatePhoneNumber() == false{
            HelperMethod.showAlertWithMessage(message: "Your phone number is wrong format")
            return false
        }
        if addressTf.text == nil || addressTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your address")
            return false
        }
        if dateOfBirthTf.text == nil || dateOfBirthTf.text == ""{
            HelperMethod.showAlertWithMessage(message: "Please enter your DOB")
            return false
        }
        return true
    }
    //
    @objc func didTapImageView(){
        print(1)
        self.setupPhotoPicker()
    }
    // MARK: ImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicker = info[.originalImage] as? UIImage
        self.avatarImageView.image = imagePicker
        let jpegData = imagePicker?.jpegData(compressionQuality: 0.4)
        self.imageData = jpegData
        self.dismiss(animated: true, completion: nil)
    }
}
