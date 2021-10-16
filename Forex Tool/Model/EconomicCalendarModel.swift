//
//  EconomicCalendarModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/10/2021.
//

import Foundation
import SwiftyJSON
class EconomicCalendarModel{
    public private(set) var title:String?
    public private(set) var indicator:String?
    public private(set) var comment:String?
    public private(set) var country:String?
    public private(set) var currency:String?
    public private(set) var importance:String?
    public private(set) var period:String?
    public private(set) var actual:String?
    public private(set) var forecast:String?
    public private(set) var previous:String?
    public private(set) var source:String?
    public private(set) var scale:String?
    public private(set) var unit:String?
    public private(set) var date:String?
    
    init(json:JSON){
        self.title = json["title"].stringValue
        self.indicator = json["indicator"].stringValue
        self.comment = json["comment"].stringValue
        self.country = json["country"].stringValue
        self.currency = json["currency"].stringValue
        self.importance = json["importance"].stringValue
        self.period = json["period"].stringValue
        self.actual = json["actual"].stringValue
        self.forecast = json["forecast"].stringValue
        self.previous = json["previous"].stringValue
        self.source = json["source"].stringValue
        self.scale = json["scale"].stringValue
        self.unit = json["unit"].stringValue
        self.date = json["date"].stringValue
    }
}
