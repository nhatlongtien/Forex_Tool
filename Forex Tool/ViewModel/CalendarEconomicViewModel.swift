//
//  CalendarEconomicViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/12/2021.
//

import Foundation
class CalendarEconomicViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    func getCalenderEconomic(important:Int, date:String, completionHandler:@escaping(_ result:Bool, _ calendars:[CalendarEconomicModel]?) -> Void){
        beforeApiCall?()
        MGConnection.requestFor247Feed(APIRouter.calendarEconomic(important: important, date: date)) { result, err in
            if let err = err{
                print("False with code: \(err.mErrorCode) and message: \(err.mErrorMessage)")
                self.afterApiCall?()
                completionHandler(false, nil)
            }else{
                var calendarReturn:[CalendarEconomicModel] = []
                guard let listData = result!["list"].array else {return}
                for eachData in listData{
                    let calender = CalendarEconomicModel(json: eachData)
                    calendarReturn.append(calender)
                }
                self.afterApiCall?()
                completionHandler(true, calendarReturn)
            }
        }
    }

}
