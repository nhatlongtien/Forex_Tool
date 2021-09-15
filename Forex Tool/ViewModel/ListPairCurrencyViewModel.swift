//
//  ListPairCurrencyViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON
class ListPairCurrencyViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    
    let db = Firestore.firestore()
    
    func getListPairCurrency(completionHanler:@escaping(_ result:Bool, _ listCurrency:[PairCurrencyModel]?) -> Void){
        beforeApiCall!()
        db.collection("ListCurrency").getDocuments { [self] (snapShot, error) in
            if let err = error{
                completionHanler(false, nil)
                HelperMethod.showAlertWithMessage(message: err.localizedDescription ?? "")
            }else{
                var listCurrency:[PairCurrencyModel] = []
                for document in snapShot!.documents{
                    guard let json = JSON(rawValue: document.data()) else {return}
                    let currency = PairCurrencyModel(json: json)
                    listCurrency.append(currency)
                }
                completionHanler(true, listCurrency)
            }
            afterApiCall!()
        }
    }
}

