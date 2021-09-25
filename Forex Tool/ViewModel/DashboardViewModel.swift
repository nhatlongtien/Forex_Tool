//
//  DashboardViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 17/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON
class DashboardViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    //
    func getListTransaction(isFillter:Bool, fromDate:Date?, toDate:Date?, statusTransaction:String?, resultTransaction:String?, completionHander:@escaping(_ result:Bool,_ listTransaction:[TransactionModel]?) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        var returnListTransaction:[TransactionModel] = []
        if isFillter == true{
            db.collection("Transactions").whereField("userID", isEqualTo: Constant.defaults.string(forKey: Constant.USER_ID)).order(by: "timeStamp", descending: true).getDocuments { [self] (querySnapshot, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    HelperMethod.showAlertWithMessage(message: "Error getting documents: \(err)")
                    completionHander(false, nil)
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        guard let json = JSON(rawValue: document.data()) else {return}
                        let transaction = TransactionModel(json: json, documentID: document.documentID)
                        if fromDate == nil && toDate == nil && statusTransaction != nil && resultTransaction == nil{ //Filter by status
                            if transaction.status == statusTransaction{
                                returnListTransaction.append(transaction)
                            }
                        }else if fromDate == nil && toDate == nil && statusTransaction == nil && resultTransaction != nil{ //Filter by result
                            if transaction.detail?.result == resultTransaction{
                                returnListTransaction.append(transaction)
                            }
                        }else if fromDate != nil && toDate != nil && statusTransaction == nil && resultTransaction == nil{ //Filter by date
                            print("Filter by date")
                        }
                    }
                }
                completionHander(true, returnListTransaction)
                afterApiCall?()
            }
        }else{
            
            db.collection("Transactions").whereField("userID", isEqualTo: Constant.defaults.string(forKey: Constant.USER_ID)).order(by: "timeStamp", descending: true).getDocuments { [self] (querySnapshot, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    HelperMethod.showAlertWithMessage(message: "Error getting documents: \(err)")
                    completionHander(false, nil)
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        guard let json = JSON(rawValue: document.data()) else {return}
                        let transaction = TransactionModel(json: json, documentID: document.documentID)
                        returnListTransaction.append(transaction)
                    }
                }
                completionHander(true, returnListTransaction)
                afterApiCall?()
            }
        }
        
    }
    //
    func getListTransactionByDate(startDate:Date, toDate:Date, completionHander:@escaping(_ result:Bool, _ listTransaction:[TransactionModel]?) -> Void){
        var returnListTransaction:[TransactionModel] = []
        let db = Firestore.firestore()
        let startTimestamp = Timestamp(date: startDate)
        let toDateTimestamp = Timestamp(date: toDate)
        print(startTimestamp)
        print(toDateTimestamp)
        print(Timestamp(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!))
        beforeApiCall?()
        
        db.collection("Transactions").whereField("userID", isEqualTo: Constant.defaults.value(forKey: Constant.USER_ID)).whereField("timeStamp", isGreaterThanOrEqualTo: startTimestamp).whereField("timeStamp", isLessThanOrEqualTo: toDateTimestamp).order(by: "timeStamp", descending: true).getDocuments { [self] (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
                HelperMethod.showAlertWithMessage(message: "Error getting documents: \(err)")
                print(err)
                completionHander(false, nil)
            }else{
                for document in querySnapshot!.documents{
                    print("scssscscscscscscscsc\(document.documentID) => \(document.data())")
                    guard let json = JSON(rawValue: document.data()) else {return}
                    let transaction = TransactionModel(json: json, documentID: document.documentID)
                    returnListTransaction.append(transaction)
                }
                completionHander(true, returnListTransaction)
            }
            afterApiCall?()
        }
    }
    //
    func deleteTransactionByID(transactionID:String, completionHandler:@escaping(_ result:Bool) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        db.collection("Transactions").document(transactionID).delete() { [self] err in
            if let err = err {
                print("Error removing document: \(err)")
                completionHandler(false)
                HelperMethod.showAlertWithMessage(message: "Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                completionHandler(true)
            }
            afterApiCall?()
        }
    }
    //
    func getConfig(){
        let db = Firestore.firestore()
        db.collection("Config").getDocuments { (queryShnapshot, error) in
            if let err = error{
                print("Error getting documents: \(err)")
                HelperMethod.showAlertWithMessage(message: "Error getting documents: \(err)")
            }else{
                var listCrypto:[String] = []
                var listPeriod:[String] = []
                for document in queryShnapshot!.documents{
                    guard let json = JSON(rawValue: document.data()) else {return}
                    guard let listCryptoJson = json["pairRatioCurrency"].array else {return}
                    for eachCrypto in listCryptoJson {
                        listCrypto.append(eachCrypto.stringValue)
                    }
                    guard let listPeriodJson = json["periodTime"].array else {return}
                    for eachPeriod in listPeriodJson{
                        listPeriod.append(eachPeriod.stringValue)
                    }
                }
                Constant.defaults.set(listCrypto, forKey: Constant.CRYPTO_KEY)
                Constant.defaults.set(listPeriod, forKey: Constant.PERIOD_TIME_KEY)
                print(listCrypto)
                print(listPeriod)
            }
        }
    }
    //
    func getUserInfoByUserID(userID:String, completionHandler:@escaping(_ result:Bool,_ userInfo:UserModel?) -> Void){
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        beforeApiCall?()
        let docRef = db.collection("users").whereField("uid", isEqualTo: userID).getDocuments { [self] (result, error) in
            if let error = error{
                print("Error getting documents: \(error)")
                HelperMethod.showAlertWithMessage(message: "Error getting documents: \(error)")
                completionHandler(false, nil)
            }else{
                let user = result?.documents.first?.data()
                guard let userJson = JSON(rawValue: user) else {return}
                let userReturn = UserModel(json: userJson, documentID: result?.documents.first?.documentID)
                completionHandler(true, userReturn)
            }
            afterApiCall?()
        }
    }
}
