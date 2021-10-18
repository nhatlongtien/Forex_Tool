//
//  Enum.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 14/07/2021.
//

import Foundation
import UIKit
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
    case MM_DD_HH_mm = "MM/dd HH:mm"
    case YYYY_MM_DD_T_HH_mm_ssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case HH_mm = "HH:mm"
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
enum MethodLoginType:String{
    case gmail = "Gmail"
    case facebook = "Facebook"
    case email_password = "Email_Password"
    case apple = "Apple"
}
enum TabItem:String, CaseIterable{
    case home = "Home"
    case market = "Market"
    case ecomomicNew = "Ecomomic News"
    case caculationTool = "Calculation"
    case profile = "Profile"
    
    var viewController:UIViewController{
        switch self {
        case .home:
            return DashboardViewController()
        case .ecomomicNew:
            return HomeNewsViewController()
        case .market:
            return HomeMarketViewController()
        case .profile:
            return ProfileViewController()
        case .caculationTool:
            return HomeCalculationViewController()
        default:
            break
        }
    }
    
    var icon:UIImage{
        switch self {
        case .home:
            return UIImage(named: "homeIcon")!
        case .caculationTool:
            return UIImage(named: "calculationIcon")!
        case .ecomomicNew:
            return UIImage(named: "newsIcon")!
        case .market:
            return UIImage(named: "globalMarket")!
        case .profile:
            return UIImage(named: "profileIcon")!
        default:
            break
        }
    }
    var displayTitle:String{
        return self.rawValue.capitalized(with: nil)
    }
}
enum DurationTime:String{
    case today = "Today"
    case tomorrow = "Tomorrow"
    case thisWeek = "This Week"
}

