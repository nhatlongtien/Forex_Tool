//
//  HomeMarketViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 04/10/2021.
//

import Foundation
import Alamofire
import SwiftyJSON
class HomeMarketViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    
    func getInfoPairCurrency(symbol:String, completionHandler:@escaping(_ result:Bool, _ listInfoPairCurrency:[PricePairCurrencyModel]?) -> Void){
        beforeApiCall?()
        AF.request("https://fcsapi.com/api-v3/forex/latest?symbol=\(symbol)&access_key=\(Constant.API_ACCESS_KEY)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                guard let json = JSON(rawValue: value) else {return}
                let status = json["status"].boolValue
                if status == true{
                    var listInfoCurrency:[PricePairCurrencyModel] = []
                    guard let response = json["response"].array else {return}
                    for eachData in response{
                        let infoPairCurrency = PricePairCurrencyModel(json: eachData)
                        listInfoCurrency.append(infoPairCurrency)
                    }
                    completionHandler(true, listInfoCurrency)
                }else{
                    let message = json["msg"].stringValue
                    HelperMethod.showAlertWithMessage(message: message)
                    completionHandler(false, nil)
                }
                print("Success")
            case .failure(let error):
                HelperMethod.showAlertWithMessage(message: error.localizedDescription ?? "")
                completionHandler(false, nil)
            }
            self.afterApiCall?()
        }
    }
}
