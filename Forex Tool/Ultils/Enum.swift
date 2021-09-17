//
//  Enum.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 14/07/2021.
//

import Foundation
enum CurrencyGroup:String{
    case XXX_USD = "XXX_USD"
    case USD_XXX = "USD_XXX"
    case XXX_JPY = "XXX_JPY"
    case XAU_USD = "XAU_USD"
    case BTC_USD = "BTC_USD"
    case XXX_XXX = "XXX_XXX"
}
enum TypeTransaction:String{
    case Buy = "Buy"
    case Sell = "Sell"
    case BuyLimit = "Buy Limit"
    case SellLimit = "Sell Limit"
}
enum DateformatterType:String{
    case YYYY_MM_DD_HHMMSS = "yyyy-MM-dd HH:mm:ss"
    case DD_MM_YYYY = "dd-MM-yyyy"
    case DD_MM_YYYY_Slash = "dd/MM/yyyy"
    case YYYY_MM_DD = "yyyy-MM-dd"
    case MMMM_D_YYYY_HH_mm_ss = "MMMM d, yyyy HH:mm:ss"
    case DD_MMMM = "dd MMMM"
}
enum StatusTransaction:String{
    case Active = "Active"
    case Pending = "Pending"
    case Complete = "Complete"
}
enum ResultTransaction:String{
    case Win = "Win"
    case Loss = "Loss"
    case Unknow = "Unknow"
}
enum NewsLinkRSSFeed:String{
    case crypto = "https://vn.investing.com/rss/news_301.rss"
    case forex = "https://vn.investing.com/rss/news_1.rss"
    case popular = "https://vn.investing.com/rss/news_285.rss"
    case goods = "https://vn.investing.com/rss/news_11.rss"
    case stock = "https://vn.investing.com/rss/news_25.rss"
    case indexEconomic = "https://vn.investing.com/rss/news_95.rss"
    case economic = "https://vn.investing.com/rss/news_14.rss"
    case world = "https://vn.investing.com/rss/news_287.rss"
}
