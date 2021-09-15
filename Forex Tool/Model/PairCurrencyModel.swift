//
//  PairCurrencyModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/07/2021.
//

import Foundation
import SwiftyJSON
struct PairCurrencyModel{
    public private(set) var name:String?
    public private(set) var currency:String?
    public private(set) var group:String?
    public private(set) var toCurrency:String?
    public private(set) var fromCurrency:String?
    public private(set) var id:String!
    
    init(json:JSON) {
        self.name = json["name"].stringValue
        self.currency = json["currency"].stringValue
        self.group = json["group"].stringValue
        self.toCurrency = json["toCurrency"].stringValue
        self.fromCurrency = json["fromCurrency"].stringValue
        self.id = json["id"].stringValue
    }
}
