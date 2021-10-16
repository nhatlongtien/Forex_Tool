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
        AF.request("https://fcsapi.com/api-v3/forex/economy_cal?symbol=\(symbol)&from=\(fromDate)&to=\(toDate)&access_key=\(Constant.API_ACCESS_KEY)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                guard let json = JSON(rawValue: value) else {return}
                let status = json["status"].boolValue
                if status == true{
                    var listEconomicCalendar:[EconomicCalendarModel] = []
                    guard let response = json["response"].array else {return}
                    for eachData in response{
                        let economicCalendar = EconomicCalendarModel(json: eachData)
                        listEconomicCalendar.append(economicCalendar)
                    }
                    completionHandler(true, listEconomicCalendar)
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
