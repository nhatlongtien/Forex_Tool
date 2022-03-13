//
//  BaseViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 21/09/2021.
//

import UIKit
import AVFoundation
import Photos
protocol BaseViewControllerProtocol:class{
    func didTapCommentButton()
}
class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate:BaseViewControllerProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Roboto-Medium", size: 16), NSAttributedString.Key.foregroundColor:UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    //MARK: - Helper Method
    func setupNaivationBar(style:NavigationBarStyle){
        switch style {
        case NavigationBarStyle.comment:
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1)
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Roboto-Medium", size: 16), NSAttributedString.Key.foregroundColor:UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)]
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            //TODO: Add comment button
            //create a new button
            let button = UIButton(type: .custom)
            //set image for button
            button.setImage(UIImage(named: "comment_icon"), for: .normal)
            //add function for button
            button.addTarget(self, action: #selector(handleTapCommentBtn), for: .touchUpInside)
            //set frame
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let commentBtn = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = commentBtn
        default:
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1)
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Roboto-Medium", size: 16), NSAttributedString.Key.foregroundColor:UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)]
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        }
    }
    @objc func handleTapCommentBtn(){
//        let targetVC = CommentViewController()
//        self.navigationController?.pushViewController(targetVC, animated: true)
        delegate?.didTapCommentButton()
        
    }
    //MARK: - PHOTO AND CAMERA PERMISSION REQEUST AND SETUP PICKER
    @objc func setupPhotoPicker(){
        let photoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.accessPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })
        
        photoAlert.addAction(cameraAction)
        photoAlert.addAction(photoLibraryAction)
        photoAlert.addAction(cancelAction)
        
        self.present(photoAlert, animated: true, completion: nil)
    }
    @objc func isPermissionAllowed() -> Bool{
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized || AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined{
            print("Allow")
            return true
        }else if AVCaptureDevice.authorizationStatus(for: .video) == .denied{
            print("Denied")
            showAlertToAllowCameraPermissionInSetting()
            return false
        }
        return false
    }
    @objc func isPhotoPermissionAllowed() -> Bool{
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined{
            print("Allow")
            return true
        }else if PHPhotoLibrary.authorizationStatus() == .denied{
            print("Denied")
            showAlertToAllowPhotoPermissionInSetting()
            return false
        }
        return false
    }
    @objc func accessCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let camera = UIImagePickerController()
            camera.delegate = self
            camera.sourceType = .camera
            self.present(camera, animated: true, completion: nil)
        }else{
            print("Camera is not available")
        }
    }
    @objc func accessPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIImagePickerController()
            photoLibrary.delegate = self
            photoLibrary.sourceType = .photoLibrary
            self.present(photoLibrary, animated: true, completion: nil)
        }
    }
    
    @objc func showAlertToAllowCameraPermissionInSetting() {
        let alert = UIAlertController(title: "Allow Camera Acess", message: "Camera Access is required to take photo", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        present(alert, animated: true)
    }
    @objc func showAlertToAllowPhotoPermissionInSetting() {
        let alert = UIAlertController(title: "Allow Photo Acess", message: "Photo library Access is required to get photo", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        present(alert, animated: true)
    }
    
}
