//
//  LongShortRatioViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/09/2021.
//

import Foundation
import Alamofire
import SwiftyJSON
class LongShortRatioViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    
    func getLongShortRatio(time:String, symbol:String, completionHander:@escaping(_ result:Bool,_ ratioItem:ExchangeLongShortRatioModel?) -> Void){
        beforeApiCall?()
        AF.request("https://fapi.bybt.com/api/futures/longShortRate?timeType=\(time)&symbol=\(symbol)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (respone) in
            switch respone.result{
            case .success(let value):
                var retunItem:ExchangeLongShortRatioModel?
                guard let json = JSON(rawValue: value) else {return}
                let code = json["code"].stringValue
                let mess = json["msg"].stringValue
                if code == "0"{
                    guard let dataJson = json["data"].array else {return}
                    let firstDataJson = dataJson.first
                    guard let listJson = firstDataJson!["list"].array else {return}
                    retunItem = ExchangeLongShortRatioModel(json: firstDataJson!, listJson: listJson)
                    completionHander(true, retunItem)
                    self.afterApiCall?()
                }else{
                    completionHander(false, nil)
                    self.afterApiCall?()
                    HelperMethod.showAlertWithMessage(message: mess)
                }
                
            case .failure(let error):
                completionHander(false, nil)
                print(error.localizedDescription)
                self.afterApiCall?()
            }
        }
    }
}
