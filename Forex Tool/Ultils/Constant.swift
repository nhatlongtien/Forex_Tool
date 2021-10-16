//
//  Constant.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 09/07/2021.
//

import Foundation
import UIKit
class Constant{
    static let API_ACCESS_KEY = "Muc5Gx8l1BhOGAqyNFJQPCxUF"
    static var USER_ID:String = "USER_ID"
    static var CRYPTO_KEY = "CRYPTO_KEY"
    static var PERIOD_TIME_KEY = "PERIOD_TIME_KEY"
    static var METHOD_LOG_IN_KEY = "METHOD_LOGIN_KEY"
    static let defaults = UserDefaults.standard
    static let listCurrency:[CurrencyModel] = [
        CurrencyModel(name: "AUD/CAD", currency: "USD", group: "XXX_XXX", id: "001", fromCurrency: "AUD", toCururrency: "CAD"),
        CurrencyModel(name: "AUD/CHF", currency: "USD", group: "XXX_XXX", id: "002", fromCurrency: "AUD", toCururrency: "CHF"),
        CurrencyModel(name: "AUD/JPY", currency: "USD", group: "XXX_JPY", id: "003", fromCurrency: "AUD", toCururrency: "JPY"),
        CurrencyModel(name: "AUD/NZD", currency: "USD", group: "XXX_XXX", id: "004", fromCurrency: "AUD", toCururrency: "NZD"),
        CurrencyModel(name: "AUD/USD", currency: "USD", group: "XXX_USD", id: "005", fromCurrency: "AUD", toCururrency: "USD"),
        CurrencyModel(name: "AUD/NOK", currency: "USD", group: "XXX_XXX", id: "053", fromCurrency: "AUD", toCururrency: "NOK"),
        CurrencyModel(name: "AUD/PLN", currency: "USD", group: "XXX_XXX", id: "054", fromCurrency: "AUD", toCururrency: "PLN"),
        CurrencyModel(name: "AUD/SEK", currency: "USD", group: "XXX_XXX", id: "055", fromCurrency: "AUD", toCururrency: "SEK"),
        CurrencyModel(name: "AUD/SGD", currency: "USD", group: "XXX_XXX", id: "056", fromCurrency: "AUD", toCururrency: "SGD"),
        CurrencyModel(name: "CAD/CHF", currency: "USD", group: "XXX_XXX", id: "006", fromCurrency: "CAD", toCururrency: "CHF"),
        CurrencyModel(name: "CAD/JPY", currency: "USD", group: "XXX_JPY", id: "007", fromCurrency: "CAD", toCururrency: "JPY"),
        CurrencyModel(name: "CAD/SGD", currency: "USD", group: "XXX_XXX", id: "057", fromCurrency: "CAD", toCururrency: "SGD"),
        CurrencyModel(name: "CHF/JPY", currency: "USD", group: "XXX_JPY", id: "008", fromCurrency: "CHF", toCururrency: "JPY"),
        CurrencyModel(name: "CHF/SGD", currency: "USD", group: "XXX_XXX", id: "058", fromCurrency: "CHF", toCururrency: "SGD"),
        CurrencyModel(name: "EUR/AUD", currency: "USD", group: "XXX_XXX", id: "009", fromCurrency: "EUR", toCururrency: "AUD"),
        CurrencyModel(name: "EUR/CAD", currency: "USD", group: "XXX_XXX", id: "010", fromCurrency: "EUR", toCururrency: "CAD"),
        CurrencyModel(name: "EUR/CHF", currency: "USD", group: "XXX_XXX", id: "011", fromCurrency: "EUR", toCururrency: "CHF"),
        CurrencyModel(name: "EUR/DKK", currency: "USD", group: "XXX_XXX", id: "012", fromCurrency: "EUR", toCururrency: "DKK"),
        CurrencyModel(name: "EUR/GBP", currency: "USD", group: "XXX_XXX", id: "013", fromCurrency: "EUR", toCururrency: "GBP"),
        CurrencyModel(name: "EUR/HDK", currency: "USD", group: "XXX_XXX", id: "014", fromCurrency: "EUR", toCururrency: "HDK"),
        CurrencyModel(name: "EUR/JPY", currency: "USD", group: "XXX_JPY", id: "015", fromCurrency: "EUR", toCururrency: "JPY"),
        CurrencyModel(name: "EUR/NOK", currency: "USD", group: "XXX_XXX", id: "016", fromCurrency: "EUR", toCururrency: "NOK"),
        CurrencyModel(name: "EUR/NZD", currency: "USD", group: "XXX_XXX", id: "017", fromCurrency: "EUR", toCururrency: "USD"),
        CurrencyModel(name: "EUR/PLN", currency: "USD", group: "XXX_XXX", id: "018", fromCurrency: "EUR", toCururrency: "PLN"),
        CurrencyModel(name: "EUR/SEK", currency: "USD", group: "XXX_XXX", id: "019", fromCurrency: "EUR", toCururrency: "SEK"),
        CurrencyModel(name: "EUR/TRY", currency: "USD", group: "XXX_XXX", id: "020", fromCurrency: "EUR", toCururrency: "TRY"),
        CurrencyModel(name: "EUR/HUF", currency: "USD", group: "XXX_XXX", id: "059", fromCurrency: "EUR", toCururrency: "HUF"),
        CurrencyModel(name: "EUR/CZK", currency: "USD", group: "XXX_XXX", id: "060", fromCurrency: "EUR", toCururrency: "CZK"),
        CurrencyModel(name: "EUR/MXN", currency: "USD", group: "XXX_XXX", id: "061", fromCurrency: "EUR", toCururrency: "MXN"),
        CurrencyModel(name: "EUR/RON", currency: "USD", group: "XXX_XXX", id: "062", fromCurrency: "EUR", toCururrency: "RON"),
        CurrencyModel(name: "EUR/USD", currency: "USD", group: "XXX_USD", id: "021", fromCurrency: "EUR", toCururrency: "USD"),
        CurrencyModel(name: "GBP/AUD", currency: "USD", group: "XXX_XXX", id: "022", fromCurrency: "GBP", toCururrency: "AUD"),
        CurrencyModel(name: "GBP/CAD", currency: "USD", group: "XXX_XXX", id: "023", fromCurrency: "GBP", toCururrency: "CAD"),
        CurrencyModel(name: "GBP/CHF", currency: "USD", group: "XXX_XXX", id: "024", fromCurrency: "GBP", toCururrency: "CHF"),
        CurrencyModel(name: "GBP/DKK", currency: "USD", group: "XXX_XXX", id: "025", fromCurrency: "GBP", toCururrency: "DKK"),
        CurrencyModel(name: "GBP/JPY", currency: "USD", group: "XXX_JPY", id: "026", fromCurrency: "GBP", toCururrency: "JPY"),
        CurrencyModel(name: "GBP/NZD", currency: "USD", group: "XXX_XXX", id: "027", fromCurrency: "GBP", toCururrency: "NZD"),
        CurrencyModel(name: "GBP/PLN", currency: "USD", group: "XXX_XXX", id: "028", fromCurrency: "GBP", toCururrency: "PLN"),
        CurrencyModel(name: "GBP/SEK", currency: "USD", group: "XXX_XXX", id: "029", fromCurrency: "GBP", toCururrency: "SEK"),
        CurrencyModel(name: "GBP/USD", currency: "USD", group: "XXX_USD", id: "030", fromCurrency: "GBP", toCururrency: "USD"),
        CurrencyModel(name: "NZD/CAD", currency: "USD", group: "XXX_XXX", id: "031", fromCurrency: "NZD", toCururrency: "CAD"),
        CurrencyModel(name: "NZD/CHF", currency: "USD", group: "XXX_XXX", id: "032", fromCurrency: "NZD", toCururrency: "CHF"),
        CurrencyModel(name: "NZD/JPY", currency: "USD", group: "XXX_JPY", id: "033", fromCurrency: "NZD", toCururrency: "JPY"),
        CurrencyModel(name: "NZD/USD", currency: "USD", group: "XXX_USD", id: "034", fromCurrency: "NZD", toCururrency: "USD"),
        CurrencyModel(name: "USD/CAD", currency: "USD", group: "USD_XXX", id: "035", fromCurrency: "USD", toCururrency: "CAD"),
        CurrencyModel(name: "USD/CHF", currency: "USD", group: "USD_XXX", id: "036", fromCurrency: "USD", toCururrency: "CHF"),
        CurrencyModel(name: "USD/CZK", currency: "USD", group: "USD_XXX", id: "037", fromCurrency: "USD", toCururrency: "CZK"),
        CurrencyModel(name: "USD/DKK", currency: "USD", group: "USD_XXX", id: "038", fromCurrency: "USD", toCururrency: "DKK"),
        CurrencyModel(name: "USD/HKD", currency: "USD", group: "USD_XXX", id: "039", fromCurrency: "USD", toCururrency: "HDK"),
        CurrencyModel(name: "USD/HKD", currency: "USD", group: "USD_XXX", id: "040", fromCurrency: "USD", toCururrency: "HDK"),
        CurrencyModel(name: "USD/HUF", currency: "USD", group: "USD_XXX", id: "041", fromCurrency: "USD", toCururrency: "HUF"),
        CurrencyModel(name: "USD/JPY", currency: "USD", group: "XXX_JPY", id: "042", fromCurrency: "USD", toCururrency: "JPY"),
        CurrencyModel(name: "USD/MXN", currency: "USD", group: "USD_XXX", id: "043", fromCurrency: "USD", toCururrency: "MXN"),
        CurrencyModel(name: "USD/NOK", currency: "USD", group: "USD_XXX", id: "044", fromCurrency: "USD", toCururrency: "NOK"),
        CurrencyModel(name: "USD/PLN", currency: "USD", group: "USD_XXX", id: "045", fromCurrency: "USD", toCururrency: "PLN"),
        CurrencyModel(name: "USD/SEK", currency: "USD", group: "USD_XXX", id: "046", fromCurrency: "USD", toCururrency: "SEK"),
        CurrencyModel(name: "USD/SGD", currency: "USD", group: "USD_XXX", id: "047", fromCurrency: "USD", toCururrency: "SGD"),
        CurrencyModel(name: "USD/TRY", currency: "USD", group: "USD_XXX", id: "048", fromCurrency: "USD", toCururrency: "TRY"),
        CurrencyModel(name: "USD/ZAR", currency: "USD", group: "USD_XXX", id: "049", fromCurrency: "USD", toCururrency: "ZAR"),
        CurrencyModel(name: "XAG/USD", currency: "USD", group: "XAG_USD", id: "050", fromCurrency: "XAG", toCururrency: "USD"),
        CurrencyModel(name: "XAU/USD", currency: "USD", group: "XAU_USD", id: "051", fromCurrency: "XAU", toCururrency: "USD"),
        CurrencyModel(name: "BTC/USD", currency: "BTC", group: "BTC_USD", id: "052", fromCurrency: "BTC", toCururrency: "USD")
    ]
    static let SymbolMarket = "AUD/CAD,AUD/CHF,AUD/JPY,AUD/NZD,AUD/USD,AUD/SGD,CAD/CHF,CAD/JPY,CAD/SGD,CHF/JPY,CHF/SGD,EUR/AUD,EUR/CAD,EUR/CHF,EUR/GBP,EUR/JPY,EUR/NZD,EUR/USD,GBP/CHF,GBP/JPY,GBP/NZD,GBP/USD,GBP/CAD,NZD/CAD,NZD/CHF,NZD/JPY,NZD/USD,USD/CAD,USD/CHF,USD/JPY,USD/SGD,XAG/USD,XAU/USD,BTC/USD"
    static let listRiskRateValue = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    static let listTypeTransaction = ["Buy", "Sell", "Buy Limit", "Sell Limit"]
    static let economicNewsUrl = "https://sslecal2.investing.com?columns=exc_flags,exc_currency,exc_importance,exc_actual,exc_forecast,exc_previous&features=datepicker,timezone,timeselector,filters&countries=33,14,4,34,38,32,6,11,51,5,39,72,60,110,43,35,71,22,36,26,12,9,37,25,178,10,17&calType=week&timeZone=27&lang=52"
    static let listTabNews = ["Most Popular".localized(), "Cryptocurrency".localized(), "Forex".localized(), "Commodities".localized(), "Stock Market".localized(), "Economic Indicators".localized(), "Economy".localized().localized(), "World".localized()]
    static let listTabAnalysisItems = ["Forex".localized(), "Stock Market".localized(), "Commodities".localized()]
    static var isInTabBarControll:Bool = false
    static var listFilterTransaction = ["All".localized(),"Win".localized(), "Loss".localized(), "Unknow".localized(), "Active".localized(), "Completed".localized(), "Pending".localized(), "Pair Currency".localized()]
    
}
internal struct DPDConstant {

    internal struct KeyPath {

        static let Frame = "frame"

    }

    internal struct ReusableIdentifier {

        static let DropDownCell = "DropDownCell"

    }

    internal struct UI {

        static let TextColor = UIColor.black
        static let SelectedTextColor = UIColor.black
        static let TextFont = UIFont.systemFont(ofSize: 15)
        static let BackgroundColor = UIColor(white: 0.94, alpha: 1)
        static let SelectionBackgroundColor = UIColor(white: 0.89, alpha: 1)
        static let SeparatorColor = UIColor.clear
        static let CornerRadius: CGFloat = 2
        static let RowHeight: CGFloat = 44
        static let HeightPadding: CGFloat = 20

        struct Shadow {

            static let Color = UIColor.darkGray
            static let Offset = CGSize.zero
            static let Opacity: Float = 0.4
            static let Radius: CGFloat = 8

        }

    }

    internal struct Animation {

        static let Duration = 0.15
        static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
        static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
        static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)

    }

}


