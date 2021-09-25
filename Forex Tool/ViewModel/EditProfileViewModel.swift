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
             "phoneNumber": phoneNumber
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
}
