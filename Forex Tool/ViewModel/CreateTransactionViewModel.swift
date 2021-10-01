//
//  CreateTransactionViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/07/2021.
//

import Foundation
import SwiftyJSON
import Alamofire
import FirebaseStorage

class CreateTransactionViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    
    
    func convertCurrency(fromCurrency:String, toCurrency:String, completionHandler:@escaping(_ result:Bool, _ price:Double?) -> Void){
        let headers:HTTPHeaders = [
            "x-rapidapi-key": "3aff843c44mshd2b866f2161df8dp117262jsna49992b54c29",
            "x-rapidapi-host": "currency-exchange.p.rapidapi.com"
        ]
        beforeApiCall?()
        AF.request("https://currency-exchange.p.rapidapi.com/exchange?to=\(toCurrency)&from=\(fromCurrency)&q=1.0", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let price = value as! Double
                completionHandler(true, price)
            case .failure(let error):
                HelperMethod.showAlertWithMessage(message: error.localizedDescription ?? "")
                completionHandler(false, nil)
            }
            self.afterApiCall?()
        }
    }
    //
    func uploadImageToFrirebasestore(dataImage:Data, completionHandeler:@escaping(_ result:Bool, _ imageUrl:String?) -> Void){
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        let ramdomName = "\(UUID().uuidString).jpg"
        let ref = storageRef.child("charts/\(ramdomName)")
        // Upload the file to the path
        let uploadTask = ref.putData(dataImage, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                HelperMethod.showAlertWithMessage(message: "Fail to upload image")
                completionHandeler(false, nil)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    HelperMethod.showAlertWithMessage(message: "Fail to upload image")
                    completionHandeler(false, nil)
                    return
                }
                let strUrlImage = downloadURL.absoluteString
                completionHandeler(true, strUrlImage)
            }
        }
    }
}
