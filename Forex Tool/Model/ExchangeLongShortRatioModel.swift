//
//  ExchangeLongShortRatioModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/09/2021.
//

import Foundation
import SwiftyJSON
class ExchangeLongShortRatioModel{
    public private(set) var symbol:String?
    public private(set) var longRate:Double?
    public private(set) var longVolUsd:Double?
    public private(set) var shortRate:Double?
    public private(set) var shortVolUsd:Double?
    public private(set) var exchangeLogo:String?
    public private(set) var symbolLogo:String?
    public private(set) var totalVolUsd:Double?
    public private(set) var list:[List]?
    
    init(json:JSON, listJson:[JSON]) {
        self.symbol = json["symbol"].stringValue
        self.longRate = json["longRate"].doubleValue
        self.longVolUsd = json["longVolUsd"].doubleValue
        self.shortRate = json["shortRate"].doubleValue
        self.shortVolUsd = json["shortVolUsd"].doubleValue
        self.exchangeLogo = json["exchangeLogo"].stringValue
        self.symbolLogo = json["symbolLogo"].stringValue
        self.totalVolUsd = json["symbolLogo"].doubleValue
        var list:[List] = []
        for eachItem in listJson{
            list.append(List(listJson: eachItem))
        }
        self.list = list
    }
}
class List {
    var exchangeName:String?
    var symbol:String?
    var updateTime:Int?
    var turnoverNumber:Int?
    var longRate:Double?
    var longVolUsd:Double?
    var shortRate:Double?
    var shortVolUsd:Double?
    var exchangeLogo:String?
    var symbolLogo:String?
    var totalVolUsd:Double?
    var buyTurnoverNumber:Int?
    var sellTurnoverNumber:Int?
    
    init(listJson:JSON) {
        self.exchangeName = listJson["exchangeName"].stringValue
        self.symbol = listJson["symbol"].stringValue
        self.updateTime = listJson["updateTime"].intValue
        self.turnoverNumber = listJson["turnoverNumber"].intValue
        self.longRate = listJson["longRate"].doubleValue
        self.longVolUsd = listJson["longVolUsd"].doubleValue
        self.shortRate = listJson["shortRate"].doubleValue
        self.shortVolUsd = listJson["shortVolUsd"].doubleValue
        self.exchangeLogo = listJson["exchangeLogo"].stringValue
        self.symbolLogo = listJson["symbolLogo"].stringValue
        self.totalVolUsd = listJson["totalVolUsd"].doubleValue
        self.buyTurnoverNumber = listJson["buyTurnoverNumber"].intValue
        self.sellTurnoverNumber = listJson["sellTurnoverNumber"].intValue
    }
}

