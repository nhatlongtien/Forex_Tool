//
//  FeatureModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 27/11/2021.
//

import Foundation
class FeatureModel{
    var nameIcon:String
    var title:String
    
    init(nameIcon:String, title:String) {
        self.nameIcon = nameIcon
        self.title = title
    }
    class func share() -> [FeatureModel]{
        return [
            FeatureModel(nameIcon: "calculator_icon", title: "Calculator Tool".localized()),
            FeatureModel(nameIcon: "economic_news_icon", title: "Economic News".localized()),
            FeatureModel(nameIcon: "247feedNews", title: "24/7 Feeds".localized()),
            FeatureModel(nameIcon: "analysis_icon", title: "Analysis & Opinion".localized()),
            FeatureModel(nameIcon: "create_transaction_icon", title: "Create Transaction".localized()),
            FeatureModel(nameIcon: "manage_transaction_icon", title: "Manage Transaction".localized()),
            FeatureModel(nameIcon: "economic_new_icon", title: "Economic Calendar".localized()),
            FeatureModel(nameIcon: "market_icon_color", title: "Market".localized()),
            
        ]
    }
}
