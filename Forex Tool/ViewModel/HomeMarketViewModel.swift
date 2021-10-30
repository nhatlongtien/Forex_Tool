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
    
    func infoPairCurrency(symbol:String, completionHandler:@escaping(_ result:Bool, _ listInfoPairCurrency:[PricePairCurrencyModel]?) -> Void){
        beforeApiCall?()
        MGConnection.request(APIRouter.infoPairCurrency(symbol: symbol)) { result, err in
            if let err = err{
                print("False with code: \(err.mErrorCode) and message: \(err.mErrorMessage)")
                self.afterApiCall?()
                self.afterApiCall?()
                completionHandler(false, nil)
            }else{
                var listInfoCurrency:[PricePairCurrencyModel] = []
                guard let response = result?.array else {return}
                for eachData in response{
                    let infoPairCurrency = PricePairCurrencyModel(json: eachData)
                    listInfoCurrency.append(infoPairCurrency)
                }
                self.afterApiCall?()
                completionHandler(true, listInfoCurrency)
            }
        }
    }
}
