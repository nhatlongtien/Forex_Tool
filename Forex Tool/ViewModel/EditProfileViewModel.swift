//
//  EditProfileViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 24/09/2021.
//

import Foundation
import FirebaseStorage
import Firebase
class EditProfileViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall :(() -> Void)?
    
    func updateUserByDocumentID(documentID:String, fullName:String?, phoneNumber:String?, address:String?, dateOfBirth:String?, avatarUrl:String?, completionHandler:@escaping(_ result:Bool) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        db.collection("users").document(documentID).updateData(
            ["address" : address,
             "avatarImg": avatarUrl,
             "fullName":fullName,
             "phoneNumber": phoneNumber,
             "dateOfBirth": dateOfBirth
            ]) { (err) in
            if let err = err{
                print("Error updating document: \(err)")
                HelperMethod.showAlertWithMessage(message: "Error updating document: \(err)")
                completionHandler(false)
            }else{
                print("Document successfully updated")
                completionHandler(true)
            }
            self.afterApiCall?()
        }
    }
    func updateUserByDocumentIDWithoutImage(documentID:String, fullName:String?, phoneNumber:String?, address:String?, dateOfBirth:String?, completionHandler:@escaping(_ result:Bool) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        db.collection("users").document(documentID).updateData(
            ["address" : address,
             "fullName":fullName,
             "phoneNumber": phoneNumber,
             "dateOfBirth": dateOfBirth
            ]) { (err) in
            if let err = err{
                print("Error updating document: \(err)")
                HelperMethod.showAlertWithMessage(message: "Error updating document: \(err)")
                completionHandler(false)
            }else{
                print("Document successfully updated")
                completionHandler(true)
            }
            self.afterApiCall?()
        }
    }
    func uploadImageToFrirebasestore(dataImage:Data, completionHandeler:@escaping(_ result:Bool, _ imageUrl:String?) -> Void){
        beforeApiCall?()
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
                HelperMethod.showAlertWithMessage(message: "Fail to upload avatar")
                completionHandeler(false, nil)
                self.afterApiCall?()
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    HelperMethod.showAlertWithMessage(message: "Fail to upload avatar")
                    completionHandeler(false, nil)
                    self.afterApiCall?()
                    return
                }
                let strUrlImage = downloadURL.absoluteString
                self.afterApiCall?()
                completionHandeler(true, strUrlImage)
            }
        }
    }
}
