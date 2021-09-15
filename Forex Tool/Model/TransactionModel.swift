//
//  TransactionModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 17/07/2021.
//

import Foundation
import SwiftyJSON
struct TransactionModel{
    public private(set) var dateCreate:String?
    public private(set) var groupCurrency:String?
    public private(set) var pairCurrency:String?
    public private(set) var ristRate:Double?
    public private(set) var status:String?
    public private(set) var userID:String?
    public private(set) var transactionID:String?
    var detail:DetailTransaction?
    
    init(json:JSON, documentID:String) {
        self.dateCreate = json["dateCreate"].stringValue
        self.groupCurrency = json["groupCurrency"].stringValue
        self.pairCurrency = json["pairCurrency"].stringValue
        self.ristRate = json["riskRate"].doubleValue
        self.status = json["status"].stringValue
        self.transactionID = documentID
        self.userID = json["userID"].stringValue
        self.detail = DetailTransaction(
            RRRate: json["detail"]["RRRate"].stringValue,
            entryPoint: json["detail"]["entryPoint"].doubleValue,
            lotSize: json["detail"]["lotSize"].doubleValue,
            pipsLoss: json["detail"]["pipsLoss"].doubleValue,
            pipsProfit: json["detail"]["pipsProfit"].doubleValue,
            stopLossPoint: json["detail"]["stopLossPoint"].doubleValue,
            takeProfitPoint: json["detail"]["takeProfitPoint"].doubleValue,
            type: json["detail"]["type"].stringValue,
            result: json["detail"]["result"].stringValue,
            rewardMoney: json["detail"]["rewardMoney"].doubleValue,
            lossMoney: json["detail"]["lossMoney"].doubleValue
        )
        
    }
    
}
struct DetailTransaction{
    var RRRate:String?
    var entryPoint:Double?
    var lotSize:Double?
    var pipsLoss:Double?
    var pipsProfit:Double?
    var stopLossPoint:Double?
    var takeProfitPoint:Double?
    var type:String?
    var result:String?
    var rewardMoney:Double?
    var lossMoney:Double?
}
