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
    // ============ End define api ============
    
    // MARK: - HTTPMethod
    private var method:HTTPMethod{
        switch self{
        case .economicCalendar, .infoPairCurrency:
            return .get
        }
    }
    //MARK: - Path
    private var path:String{
        switch self{
        case .economicCalendar(let symbol, let fromDate, let toDate):
            return "forex/economy_cal?symbol=\(symbol)&from=\(fromDate)&to=\(toDate)&access_key=\(Constant.API_ACCESS_KEY)"
        case .infoPairCurrency(let symbol):
            return "forex/latest?symbol=\(symbol)&access_key=\(Constant.API_ACCESS_KEY)"
        }
    }
    //MARK: - Headers
    private var headers:HTTPHeaders{
        var headers:HTTPHeaders = ["Accept": "application/json"]
        switch self{
        case .economicCalendar, .infoPairCurrency:
            break
        }
        return headers
    }
    // MARK: - Parameters
    private var parameters:Parameters?{
        switch self{
        case .economicCalendar, .infoPairCurrency:
            return nil
        }
    }
    //MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        //Setting path
        var urlRequest:URLRequest = URLRequest(url: URL(string: Constant.BASE_URL + path)!)
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
