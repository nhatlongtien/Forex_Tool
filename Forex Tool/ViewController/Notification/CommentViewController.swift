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
import SwiftUI
import Photos
import Lightbox
class CommentViewController: BaseViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var noCommentHereTitle: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var messTextView: UITextView!
    @IBOutlet weak var sendBoxView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightChatBoxView: NSLayoutConstraint!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var sendBoxBottonAnchor: NSLayoutConstraint!
    var isTapImageButton = false
    var notificationItem:NotificationModel?
    var ref:DatabaseReference!
    var attachImage:Data?
    let editProfileVM = EditProfileViewModel()
    let commentVM = CommentViewModel()
    var listComment = [CommentModel]()
    var images = [UIImage]()
    var bottomSafeArea:CGFloat = 0.0
    var recentAlbumPhoto = PHFetchResult<PHAssetCollection>()
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Comment".localized()
        //
        IQKeyboardManager.shared.enable = false
        //
        getPermissionIfNecessary { granted in
            if granted{
                print("Alow")
                self.getPhotos()
            }else{
                print("Not alow")
            }
          
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        messTextView.resignFirstResponder()
        //
        self.images.removeAll()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *){
            bottomSafeArea = view.safeAreaInsets.bottom
        }else{
            bottomSafeArea = bottomLayoutGuide.length
        }
        print("bottomSafeArea: \(bottomSafeArea)")
    }
    
    //MARK: UI Event
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
        //
        isTapImageButton = true
        messTextView.resignFirstResponder()
        heightChatBoxView.constant = view.frame.height/2
    }
    //MARK: Helper Method
    func setupUI(){
        ref = Database.database().reference()
        //
        noCommentHereTitle.text = "No available comment in here!".localized()
        //
        heightChatBoxView.constant = 42
        //
        messTextView.textColor = .lightGray
        messTextView.delegate = self
        //TODO: setup commentTableView
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
        //TODO: Observe Comment
        self.observeComment()
        //TODO: Setup photoCollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        photoCollectionView.collectionViewLayout = layout
        photoCollectionView.contentInsetAdjustmentBehavior = .always
        let nibCell = UINib(nibName: "PhoToLibraryCollectionViewCell", bundle: nil)
        photoCollectionView.register(nibCell, forCellWithReuseIdentifier: "PhoToLibraryCollectionViewCell")
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        //TODO: Handle Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    //
    private func observeComment(){
        commentVM.observeCommentById(commentId: notificationItem!.id) { commentItem in
            self.listComment.append(commentItem)
            if self.listComment.count == 0{
                self.emptyView.isHidden = false
            }else{
                self.emptyView.isHidden = true
            }
            self.commentTableView.reloadData()
        }
    }
    //
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
      // 1
      guard PHPhotoLibrary.authorizationStatus() != .authorized else {
        completionHandler(true)
        return
      }
      // 2
      PHPhotoLibrary.requestAuthorization { status in
          completionHandler(status == .authorized ? true : false)
      }
    }
    fileprivate func getPhotos() {
        images.removeAll()
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 100
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        self.photoCollectionView.reloadData()
                        
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }
        
    }
    @objc func keyboardwillChange(notification: Notification){
        print("keyboard Will Show \(notification.name.rawValue)")
        // to get the hight of keyboard
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            //change the y of view when keyboad appearing
            if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
                self.sendBoxBottonAnchor.constant = keyboardHeight - bottomSafeArea
                self.heightChatBoxView.constant = 42
            }else{
                self.sendBoxBottonAnchor.constant = 0
                self.heightChatBoxView.constant = 42
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
        if isTapImageButton == true{
            heightChatBoxView.constant = 42
            isTapImageButton = false
        }else{
            messTextView.resignFirstResponder()
        }
        
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
//MARK: UITableViewDelegate, UITableViewDataSource
extension CommentViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.configCell(item: listComment[indexPath.row])
        cell.delegate = self
        return cell
    }
}
//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CommentViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "PhoToLibraryCollectionViewCell", for: indexPath) as! PhoToLibraryCollectionViewCell
        if indexPath.row == 0{
            cell.takePhotoView.isHidden = false
        }else{
            if images.count > 0{
                cell.takePhotoView.isHidden = true
                cell.photoImgView.image = images[indexPath.row - 1]
            }else{
                return cell
            }
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset:CGFloat = 5
        let minimumInteritemSpacing:CGFloat = 5
        let cellsPerRow = 3
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            sendButton.setBackgroundImage(UIImage(named: "gray_send"), for: .normal)
            sendButton.isUserInteractionEnabled = false
            if isPermissionAllowed() == true{
                accessCamera()
            }
            
        }else{
            let imagePicker = images[indexPath.row - 1]
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
            self.sendButton.setBackgroundImage(UIImage(named: "blu_send"), for: .normal)
            self.sendButton.isUserInteractionEnabled = true
        }
    }
}
//MARK: CommentTableViewCellDelegate
extension CommentViewController:CommentTableViewCellDelegate{
    func didTapCommentImage(image: UIImage?) {
        let images = [LightboxImage(image: image!)]
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        // Use dynamic background.
        controller.dynamicBackground = true
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
}
