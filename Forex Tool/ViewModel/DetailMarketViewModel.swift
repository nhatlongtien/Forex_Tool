//
//  DetailMarketViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/10/2021.
//

import Foundation
import SwiftyJSON
import Alamofire
class DetailMarketViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    
    func getEconomicCalendar(symbol:String, fromDate:String, toDate:String, completionHandler:@escaping(_ result:Bool, _ infoEconomicCalendar:[EconomicCalendarModel]?) -> Void){
        beforeApiCall?()
        MGConnection.request(APIRouter.economicCalendar(symbol: symbol, fromDate: fromDate, toDate: toDate)) { result, err in
            if let err = err{
                print("False with code: \(err.mErrorCode) and message: \(err.mErrorMessage)")
                self.afterApiCall?()
                completionHandler(false, nil)
            }else{
                var listEconomicCalendar:[EconomicCalendarModel] = []
                guard let response = result?.array else {return}
                for eachData in response{
                    let economicCalendar = EconomicCalendarModel(json: eachData)
                    listEconomicCalendar.append(economicCalendar)
                }
                print(result)
                self.afterApiCall?()
                completionHandler(true, listEconomicCalendar)
            }
        }
    }
}
