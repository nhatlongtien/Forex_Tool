//
//  NotificationViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON
class NotificationViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    func saveNotificationToFirebase(userInfo:[AnyHashable:Any]){
        let userID = Constant.defaults.string(forKey: Constant.USER_ID)
        if userID != nil && userID != ""{ //check userID, if nil or "" dont save
            let fcmOption = userInfo["fcm_options"] as? [String:String]
            let url = fcmOption?["image"]
            let type = userInfo["type"] as? String
            let aps = userInfo["aps"] as? [String: Any]
            let alert = aps?["alert"] as? [String: String]
            let title = alert?["title"]
            let body = alert?["body"]
            var ref:DocumentReference? = nil
            let db = Firestore.firestore()
            ref = db.collection("Notifications").addDocument(data: [
                "dateCreate":HelperMethod.convertDateToString(date: Date(), dateFormater: "yyyy-MM-dd'T'HH:mm:ssZ"),
                "timeStamp":Timestamp(date: Date()),
                "userID":userID,
                "title":title,
                "body":body,
                "urlMedia":url,
                "type":type,
                "isread":false
            ], completion: { error in
                if let err = error{
                    print("Error adding document: \(err)")
                }else{
                    print("Document added with ID: \(ref!.documentID)")
                }
            })
        }
    }
    func getListNotification(completionHander:@escaping(_ result:Bool,_ listNotification:[NotificationModel]?) -> Void){
        beforeApiCall?()
        let db = Firestore.firestore()
        db.collection("Notifications").whereField("userID", isEqualTo: Constant.defaults.string(forKey: Constant.USER_ID)).order(by: "timeStamp", descending: true).getDocuments { querySnapshot, error in
            if let err = error{
                print("Error getting documents: \(err)")
                HelperMethod.showAlertWithMessage(message: "Error getting documents: \(err)")
                completionHander(false, nil)
            }else{
                var listReturn = [NotificationModel]()
                for document in querySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    guard let json = JSON(rawValue: document.data()) else {return}
                    let notifi = NotificationModel(json: json, documentID: document.documentID)
                    listReturn.append(notifi)
                }
                completionHander(true, listReturn)
            }
            self.afterApiCall?()
        }
    }
}
