//
//  APIRouter.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 29/10/2021.
//

import Foundation
import Alamofire

enum APIRouter:URLRequestConvertible{
    // ============ Begin define api ============
    case economicCalendar(symbol:String, fromDate:String, toDate:String)
    case infoPairCurrency(symbol:String)
    case feed247News(limit:Int, page:Int)
    case calendarEconomic(important:Int, date:String)
    // ============ End define api ============
    
    // MARK: - HTTPMethod
    private var method:HTTPMethod{
        switch self{
        case .economicCalendar, .infoPairCurrency:
            return .get
        case .feed247News, .calendarEconomic:
            return .post
        }
    }
    //MARK: - Path
    private var path:String{
        switch self{
        case .economicCalendar(let symbol, let fromDate, let toDate):
            return "https://fcsapi.com/api-v3/forex/economy_cal?symbol=\(symbol)&from=\(fromDate)&to=\(toDate)&access_key=\(Constant.API_ACCESS_KEY)"
        case .infoPairCurrency(let symbol):
            return "https://fcsapi.com/api-v3/forex/latest?symbol=\(symbol)&access_key=\(Constant.API_ACCESS_KEY)"
        case .feed247News:
            return "https://www.fxtin.com/page/finance/information"
        case .calendarEconomic:
            return "https://www.fxtin.com/page/finance/calendarEvents"
        }
    }
    //MARK: - Headers
    private var headers:HTTPHeaders{
        var headers:HTTPHeaders = ["Accept": "application/json"]
        switch self{
        case .economicCalendar, .infoPairCurrency, .feed247News, .calendarEconomic:
            break
        }
        return headers
    }
    // MARK: - Parameters
    private var parameters:Parameters?{
        switch self{
        case .economicCalendar, .infoPairCurrency:
            return nil
        case .feed247News(let limit, let page):
            return [
                "limit":limit,
                "page":page
            ]
        case .calendarEconomic(let important, let date):
            return [
                "important":important,
                "date":date
            ]
        }
    }
    //MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        //Setting path
        var urlRequest:URLRequest = URLRequest(url: URL(string:path)!)
        //Seting method
        urlRequest.httpMethod = method.rawValue
        //Setting Header
        urlRequest.headers = headers
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                print("Encoding fail")
            }
        }
        return urlRequest
    }
}
