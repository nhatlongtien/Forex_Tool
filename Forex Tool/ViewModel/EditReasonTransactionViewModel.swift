//
//  EditReasonTransactionViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 03/10/2021.
//

import Foundation
import FirebaseFirestore
class EditReasonTransactionViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall :(() -> Void)?
    func updateReasonTransaction(transactionID:String,charImage:String?, hasReason:Int, description:String?, completion:@escaping(_ result:Bool) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        if charImage != nil{
            db.collection("Transactions").document(transactionID).updateData(
                ["detail.chartImage" : charImage,
                 "detail.hasReason" : hasReason,
                 "detail.reasonDescription" : description
            ]) { [self] (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                    afterApiCall?()
                    HelperMethod.showAlertWithMessage(message: "Error updating document: \(err)")
                    completion(false)
                }else{
                    afterApiCall?()
                    print("Document successfully updated")
                    completion(true)
                }
            }
        }else{
            db.collection("Transactions").document(transactionID).updateData(
                ["detail.hasReason" : hasReason,
                 "detail.reasonDescription" : description
            ]) { [self] (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                    afterApiCall?()
                    HelperMethod.showAlertWithMessage(message: "Error updating document: \(err)")
                    completion(false)
                }else{
                    afterApiCall?()
                    print("Document successfully updated")
                    completion(true)
                }
            }
        }
    }
}
