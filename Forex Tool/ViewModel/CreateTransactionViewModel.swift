//
//  CreateTransactionViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/07/2021.
//

import Foundation
import SwiftyJSON
import Alamofire

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
}
