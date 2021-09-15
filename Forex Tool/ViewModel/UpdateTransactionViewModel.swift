//
//  UpdateTransactionViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/09/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON

class UpdateTransactionViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    
    func updateTransactionByID(transactionID:String, statusTransaction:String, resultTransaction:String, completionHandler:@escaping(_ result:Bool) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        db.collection("Transactions").document(transactionID).updateData(
            ["status" : statusTransaction,
             "detail.result" : resultTransaction
             
            ]) { [self] (err) in
            if let err = err {
                print("Error updating document: \(err)")
                HelperMethod.showAlertWithMessage(message: "Error updating document: \(err)")
                completionHandler(false)
            }else{
                print("Document successfully updated")
                completionHandler(true)
            }
            afterApiCall?()
        }
    }
    
//    func deleteTransactionByID(transactionID:String, completionHandler:@escaping(_ result:Bool) -> Void){
//        beforeApiCall?()
//        let db = Firestore.firestore()
//        db.collection("Transactions").document(transactionID).delete() { [self] err in
//            if let err = err {
//                print("Error removing document: \(err)")
//                completionHandler(false)
//                HelperMethod.showAlertWithMessage(message: "Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//                completionHandler(true)
//            }
//            afterApiCall?()
//        }
//    }
}
