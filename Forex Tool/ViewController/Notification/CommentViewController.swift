//
//  CommentViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/11/2021.
//

import UIKit
import Firebase
import FirebaseDatabase
import IQKeyboardManagerSwift
import SwiftSoup
class CommentViewController: BaseViewController {
    
    @IBOutlet weak var noCommentHereTitle: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var messTextView: UITextView!
    @IBOutlet weak var sendBoxView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomAnchorTableView: NSLayoutConstraint!
    var notificationItem:NotificationModel?
    var ref:DatabaseReference!
    var attachImage:Data?
    let editProfileVM = EditProfileViewModel()
    let commentVM = CommentViewModel()
    var listComment = [CommentModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(notificationItem?.id)
        ref = Database.database().reference()
        //
        noCommentHereTitle.text = "No available comment in here!".localized()
        //
        messTextView.inputAccessoryView = sendBoxView
        messTextView.textColor = .lightGray
        messTextView.delegate = self
        //
        commentTableView.isUserInteractionEnabled = true
        commentTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDidTapView)))
        //
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentTableView.register(nib, forCellReuseIdentifier: "CommentTableViewCell")
        commentTableView.delegate = self
        commentTableView.dataSource = self
        //
        if self.listComment.count == 0{
            self.emptyView.isHidden = false
        }else{
            self.emptyView.isHidden = true
        }
        //
        commentVM.observeCommentById(commentId: notificationItem!.id) { commentItem in
            self.listComment.append(commentItem)
            if self.listComment.count == 0{
                self.emptyView.isHidden = false
            }else{
                self.emptyView.isHidden = true
            }
            self.commentTableView.reloadData()
        }
        //
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Comment".localized()
        //
        IQKeyboardManager.shared.enable = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        messTextView.resignFirstResponder()
    }
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        var postComment:Dictionary<String,String?>
        if attachImage != nil{
            editProfileVM.uploadImageToFrirebasestore(dataImage: attachImage!) { [self] success, imageUrl in
                if success{
                    guard let imageUrl = imageUrl else {return}
                    let userID = Constant.defaults.string(forKey: Constant.USER_ID)
                    let postComment:Dictionary<String,String?> = [
                        "messTxt": messTextView.text,
                        "pubdate": Date().dateToString(format: DateformatterType.dd_MM_yyyy_HH_mm.rawValue),
                        "userID": userID,
                        "mediaUrl": imageUrl,
                        "fileUrl": nil
                    ]
                    addComment(postComment: postComment)
                }
            }
        }else{// khong co hinh anh dinh kem
            let userID = Constant.defaults.string(forKey: Constant.USER_ID)
            let postComment:Dictionary<String,String?> = [
                "messTxt": messTextView.text,
                "pubdate": Date().dateToString(format: DateformatterType.dd_MM_yyyy_HH_mm.rawValue),
                "userID": userID,
                "mediaUrl": nil,
                "fileUrl": nil
            ]
            addComment(postComment: postComment)
        }
    }
    
    @IBAction func attachImgButtonWasPressed(_ sender: Any) {
        setupPhotoPicker()
    }
    //MARK: Helper Method
    @objc func keyboardwillChange(notification: Notification){
        print("keyboard Will Show \(notification.name.rawValue)")
        // to get the hight of keyboard
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            //change the y of view when keyboad appearing
            if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
                self.bottomAnchorTableView.constant = keyboardHeight
            }else{
                self.bottomAnchorTableView.constant = 50
            }
            
        }
    }
    //
    func addComment(postComment:Dictionary<String,String?>){
        self.ref.child("ListComment").child(notificationItem!.id).childByAutoId().setValue(postComment) { [self] error, snapshot in
            if let err = error{
                print(error)
            }else{
                print("Send comment success")
                messTextView.text = ""
                sendButton.setBackgroundImage(UIImage(named: "gray_send"), for: .normal)
                sendButton.isUserInteractionEnabled = false
            }
        }
    }
    @objc func handleDidTapView(){
        messTextView.resignFirstResponder()
        view.addSubview(sendBoxView)
        sendBoxView.translatesAutoresizingMaskIntoConstraints = false
        sendBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sendBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sendBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        sendBoxView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicker = info[.originalImage] as! UIImage
        //
        let imgvalue = max(imagePicker.size.width, imagePicker.size.height)
        if imgvalue >= 3000{
            attachImage = imagePicker.jpegData(compressionQuality: 0.1)
        }else if imgvalue >= 2000{
            attachImage = imagePicker.jpegData(compressionQuality: 0.2)
        }else if imgvalue >= 1000{
            attachImage = imagePicker.jpegData(compressionQuality: 0.3)
        }else{
            attachImage = imagePicker.jpegData(compressionQuality: 0.4)
        }
        self.dismiss(animated: true) {
            self.sendButton.setBackgroundImage(UIImage(named: "blu_send"), for: .normal)
            self.sendButton.isUserInteractionEnabled = true
        }
    }
}
//MARK: UITextViewDelegate
extension CommentViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messTextView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if messTextView.text == ""{
            textView.text = "Comment".localized()
            textView.textColor = .lightGray
            sendButton.setBackgroundImage(UIImage(named: "gray_send"), for: .normal)
            sendButton.isUserInteractionEnabled = false
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != ""{
            sendButton.setBackgroundImage(UIImage(named: "blu_send"), for: .normal)
            sendButton.isUserInteractionEnabled = true
        }else{
            sendButton.setBackgroundImage(UIImage(named: "gray_send"), for: .normal)
            sendButton.isUserInteractionEnabled = false
        }
    }
}
extension CommentViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.configCell(item: listComment[indexPath.row])
        return cell
    }
}

