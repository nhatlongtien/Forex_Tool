//
//  EditReasonPopupViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 03/10/2021.
//

import UIKit
import FirebaseFirestore
import PKHUD
class EditReasonPopupViewController: BaseViewController {
    
    @IBOutlet weak var chartImageView: UIImageView!
    @IBOutlet weak var reasonTextView: UITextView!
    //
    var selectedTransactionItem:TransactionModel?
    var transactionID:String?
    var dataImage:Data?
    var editReasonTransactionVM = EditReasonTransactionViewModel()
    var createTransactionVM = CreateTransactionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelCallBack()
        //
        reasonTextView.delegate = self
        showDataForUI()
        print(selectedTransactionItem)
    }
    //
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func selectImageWasPressed(_ sender: Any) {
        self.setupPhotoPicker()
    }
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        if !validate(){
            return
        }
        guard let transactionID = selectedTransactionItem?.transactionID else {return}
        if dataImage != nil{//upload image -> update
            createTransactionVM.uploadImageToFrirebasestore(dataImage: dataImage!) { [self] success, imageUrl in
                if success{
                    editReasonTransactionVM.updateReasonTransaction(transactionID: transactionID, charImage: imageUrl, hasReason: 1, description: reasonTextView.text, completion: {success in
                        if success{
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        }else{
            editReasonTransactionVM.updateReasonTransaction(transactionID: transactionID, charImage: nil, hasReason: 1, description: reasonTextView.text, completion: {success in
                if success{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    //MARK: Helper Method
    func showDataForUI(){
        if selectedTransactionItem?.detail?.hasReason == 1{
            self.title = "Edit Reason"
            reasonTextView.text = selectedTransactionItem?.detail?.reasonDescription
            if selectedTransactionItem?.detail?.chartImage != nil && selectedTransactionItem?.detail?.chartImage != ""{
                chartImageView.kf.setImage(with: URL(string: (selectedTransactionItem?.detail?.chartImage)!))
            }
        }else{
            self.title = "Add Reason"
            reasonTextView.text = "Enter your reason in here"
            reasonTextView.textColor = .lightGray
        }
    }
    func viewModelCallBack(){
        editReasonTransactionVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        editReasonTransactionVM.afterApiCall = {
            HUD.hide()
        }
        createTransactionVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        createTransactionVM.afterApiCall = {
            HUD.hide()
        }
    }
    func validate() -> Bool{
        if reasonTextView.textColor == UIColor.lightGray{
            HelperMethod.showAlertWithMessage(message: "Please enter your reason")
            return false
        }
        return true
    }
    
}
//MARK: UITextViewDelegate
extension EditReasonPopupViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Enter your reason in here!"
            textView.textColor = .lightGray
        }
    }
}
//MARK:
extension EditReasonPopupViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicker = info[.originalImage] as! UIImage
        self.chartImageView.image = imagePicker
        //
        self.dataImage = imagePicker.jpegData(compressionQuality: 0.4)
        self.dismiss(animated: true, completion: nil)
    }
}
