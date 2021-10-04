//
//  PricePairCurrencyModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 02/10/2021.
//

import Foundation
import SwiftyJSON
struct PricePairCurrencyModel{
    public private(set) var symbol:String?
    public private(set) var open:String?
    public private(set) var high:String?
    public private(set) var low:String?
    public private(set) var currentPrice:String?
    public private(set) var ask:String?
    public private(set) var bid:String?
    public private(set) var spread:String?
    public private(set) var changeInDayCandle:String?
    public private(set) var changeInPercentage:String?
    public private(set) var time:String?
    
    init(json:JSON){
        self.symbol = json["s"].stringValue
        self.open = json["o"].stringValue
        self.high = json["h"].stringValue
        self.low = json["l"].stringValue
        self.currentPrice = json["c"].stringValue
        self.ask = json["a"].stringValue
        self.bid = json["b"].stringValue
        self.spread = json["sp"].stringValue
        self.changeInDayCandle = json["ch"].stringValue
        self.changeInPercentage = json["cp"].stringValue
        self.time = json["tm"].stringValue
    }
}
