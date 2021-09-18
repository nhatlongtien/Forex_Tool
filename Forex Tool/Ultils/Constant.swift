//
//  Constant.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 09/07/2021.
//

import Foundation
import UIKit
class Constant{
    static var USER_ID:String = "USER_ID"
    static var CRYPTO_KEY = "CRYPTO_KEY"
    static var PERIOD_TIME_KEY = "PERIOD_TIME_KEY"
    static let defaults = UserDefaults.standard
    static let listCurrency:[CurrencyModel] = [
        CurrencyModel(name: "AUDCAD", currency: "USD", group: "XXX_XXX", id: "001", fromCurrency: "AUD", toCururrency: "CAD"),
        CurrencyModel(name: "AUDCHF", currency: "USD", group: "XXX_XXX", id: "002", fromCurrency: "AUD", toCururrency: "CHF"),
        CurrencyModel(name: "AUDJPY", currency: "USD", group: "XXX_JPY", id: "003", fromCurrency: "AUD", toCururrency: "JPY"),
        CurrencyModel(name: "AUDNZD", currency: "USD", group: "XXX_XXX", id: "004", fromCurrency: "AUD", toCururrency: "NZD"),
        CurrencyModel(name: "AUDUSD", currency: "USD", group: "XXX_USD", id: "005", fromCurrency: "AUD", toCururrency: "USD"),
        CurrencyModel(name: "CADCHF", currency: "USD", group: "XXX_XXX", id: "006", fromCurrency: "CAD", toCururrency: "CHF"),
        CurrencyModel(name: "CADJPY", currency: "USD", group: "XXX_XXX", id: "007", fromCurrency: "CAD", toCururrency: "JPY"),
        CurrencyModel(name: "CHFJPY", currency: "USD", group: "XXX_XXX", id: "008", fromCurrency: "CHF", toCururrency: "JPY"),
        CurrencyModel(name: "EURAUD", currency: "USD", group: "XXX_XXX", id: "009", fromCurrency: "EUR", toCururrency: "AUD"),
        CurrencyModel(name: "EURCAD", currency: "USD", group: "XXX_XXX", id: "010", fromCurrency: "EUR", toCururrency: "CAD"),
        CurrencyModel(name: "EURCHF", currency: "USD", group: "XXX_XXX", id: "011", fromCurrency: "EUR", toCururrency: "CHF"),
        CurrencyModel(name: "EURDKK", currency: "USD", group: "XXX_XXX", id: "012", fromCurrency: "EUR", toCururrency: "DKK"),
        CurrencyModel(name: "EURGBP", currency: "USD", group: "XXX_XXX", id: "013", fromCurrency: "EUR", toCururrency: "GBP"),
        CurrencyModel(name: "EURHDK", currency: "USD", group: "XXX_XXX", id: "014", fromCurrency: "EUR", toCururrency: "HDK"),
        CurrencyModel(name: "EURJPY", currency: "USD", group: "XXX_JPY", id: "015", fromCurrency: "EUR", toCururrency: "JPY"),
        CurrencyModel(name: "EURNOK", currency: "USD", group: "XXX_XXX", id: "016", fromCurrency: "EUR", toCururrency: "NOK"),
        CurrencyModel(name: "EURNZD", currency: "USD", group: "XXX_XXX", id: "017", fromCurrency: "EUR", toCururrency: "USD"),
        CurrencyModel(name: "EURPLN", currency: "USD", group: "XXX_XXX", id: "018", fromCurrency: "EUR", toCururrency: "PLN"),
        CurrencyModel(name: "EURSEK", currency: "USD", group: "XXX_XXX", id: "019", fromCurrency: "EUR", toCururrency: "SEK"),
        CurrencyModel(name: "EURTRY", currency: "USD", group: "XXX_XXX", id: "020", fromCurrency: "EUR", toCururrency: "TRY"),
        CurrencyModel(name: "EURUSD", currency: "USD", group: "XXX_USD", id: "021", fromCurrency: "EUR", toCururrency: "USD"),
        CurrencyModel(name: "GBPAUD", currency: "USD", group: "XXX_XXX", id: "022", fromCurrency: "GBP", toCururrency: "AUD"),
        CurrencyModel(name: "GBPCAD", currency: "USD", group: "XXX_XXX", id: "023", fromCurrency: "GBP", toCururrency: "CAD"),
        CurrencyModel(name: "GBPCHF", currency: "USD", group: "XXX_XXX", id: "024", fromCurrency: "GBP", toCururrency: "CHF"),
        CurrencyModel(name: "GBPDKK", currency: "USD", group: "XXX_XXX", id: "025", fromCurrency: "GBP", toCururrency: "DKK"),
        CurrencyModel(name: "GBPJPY", currency: "USD", group: "XXX_JPY", id: "026", fromCurrency: "GBP", toCururrency: "JPY"),
        CurrencyModel(name: "GBPNZD", currency: "USD", group: "XXX_XXX", id: "027", fromCurrency: "GBP", toCururrency: "NZD"),
        CurrencyModel(name: "GBPPLN", currency: "USD", group: "XXX_XXX", id: "028", fromCurrency: "GBP", toCururrency: "PLN"),
        CurrencyModel(name: "GBPSEK", currency: "USD", group: "XXX_XXX", id: "029", fromCurrency: "GBP", toCururrency: "SEK"),
        CurrencyModel(name: "GBPUSD", currency: "USD", group: "XXX_USD", id: "030", fromCurrency: "GBP", toCururrency: "USD"),
        CurrencyModel(name: "NZDCAD", currency: "USD", group: "XXX_XXX", id: "031", fromCurrency: "NZD", toCururrency: "CAD"),
        CurrencyModel(name: "NZDCHF", currency: "USD", group: "XXX_XXX", id: "032", fromCurrency: "NZD", toCururrency: "CHF"),
        CurrencyModel(name: "NZDJPY", currency: "USD", group: "XXX_JPY", id: "033", fromCurrency: "NZD", toCururrency: "JPY"),
        CurrencyModel(name: "NZDUSD", currency: "USD", group: "XXX_USD", id: "034", fromCurrency: "NZD", toCururrency: "USD"),
        CurrencyModel(name: "USDCAD", currency: "USD", group: "USD_XXX", id: "035", fromCurrency: "USD", toCururrency: "CAD"),
        CurrencyModel(name: "USDCHF", currency: "USD", group: "USD_XXX", id: "036", fromCurrency: "USD", toCururrency: "CHF"),
        CurrencyModel(name: "USDCZK", currency: "USD", group: "USD_XXX", id: "037", fromCurrency: "USD", toCururrency: "CZK"),
        CurrencyModel(name: "USDDKK", currency: "USD", group: "USD_XXX", id: "038", fromCurrency: "USD", toCururrency: "DKK"),
        CurrencyModel(name: "USDHKD", currency: "USD", group: "USD_XXX", id: "039", fromCurrency: "USD", toCururrency: "HDK"),
        CurrencyModel(name: "USDHKD", currency: "USD", group: "USD_XXX", id: "040", fromCurrency: "USD", toCururrency: "HDK"),
        CurrencyModel(name: "USDHUF", currency: "USD", group: "USD_XXX", id: "041", fromCurrency: "USD", toCururrency: "HUF"),
        CurrencyModel(name: "USDJPY", currency: "USD", group: "XXX_JPY", id: "042", fromCurrency: "USD", toCururrency: "JPY"),
        CurrencyModel(name: "USDMXN", currency: "USD", group: "USD_XXX", id: "043", fromCurrency: "USD", toCururrency: "MXN"),
        CurrencyModel(name: "USDNOK", currency: "USD", group: "USD_XXX", id: "044", fromCurrency: "USD", toCururrency: "NOK"),
        CurrencyModel(name: "USDPLN", currency: "USD", group: "USD_XXX", id: "045", fromCurrency: "USD", toCururrency: "PLN"),
        CurrencyModel(name: "USDSEK", currency: "USD", group: "USD_XXX", id: "046", fromCurrency: "USD", toCururrency: "SEK"),
        CurrencyModel(name: "USDSGD", currency: "USD", group: "USD_XXX", id: "047", fromCurrency: "USD", toCururrency: "SGD"),
        CurrencyModel(name: "USDTRY", currency: "USD", group: "USD_XXX", id: "048", fromCurrency: "USD", toCururrency: "TRY"),
        CurrencyModel(name: "USDZAR", currency: "USD", group: "USD_XXX", id: "049", fromCurrency: "USD", toCururrency: "ZAR"),
        CurrencyModel(name: "XAGUSD", currency: "USD", group: "XAG_USD", id: "050", fromCurrency: "XAG", toCururrency: "USD"),
        CurrencyModel(name: "XAUUSD", currency: "USD", group: "XAU_USD", id: "051", fromCurrency: "XAU", toCururrency: "USD"),
        CurrencyModel(name: "BTCUSD", currency: "BTC", group: "BTC_USD", id: "052", fromCurrency: "BTC", toCururrency: "USD")
    ]
    static let listRiskRateValue = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    static let listTypeTransaction = ["Buy", "Sell", "Buy Limit", "Sell Limit"]
    static let economicNewsUrl = "https://sslecal2.investing.com?columns=exc_flags,exc_currency,exc_importance,exc_actual,exc_forecast,exc_previous&features=datepicker,timezone,timeselector,filters&countries=33,14,4,34,38,32,6,11,51,5,39,72,60,110,43,35,71,22,36,26,12,9,37,25,178,10,17&calType=week&timeZone=27&lang=52"
    static let listTabNews = ["Phổ Biến Nhất", "Tiền Điện Tử", "Forex", "Hàng Hoá", "Thị Trường Chúng Khoán", "Chỉ Số Kinh Tế", "Kinh Tế", "Thế Giới"]
    
    
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


