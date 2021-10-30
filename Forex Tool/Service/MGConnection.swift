//
//  MGConnection.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 29/10/2021.
//

import Foundation
import Alamofire
import SwiftyJSON
class MGConnection{
    static func isConnectedToInternet() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    static func request(_ apiRouter: APIRouter, completion: @escaping (_ responseData: JSON?, _ error: BaseResponseError?) -> Void) {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            print("No internet connection")
            return
        }
        AF.request(apiRouter).responseJSON { response in
            switch response.result {
            case .success (let value):
                guard let json = JSON(rawValue: value) else {return}
                let responseJson = BaseResponse(json: json)
                if responseJson.code == 200 {
                    if (responseJson.isSuccessCode())! {
                        completion(responseJson.response, nil)
                    } else {
                        let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.API_ERROR, (responseJson.code)!, (responseJson.msg)!)
                        completion(nil, err)
                    }
                } else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, "Request is error!")
                    completion(nil, err)
                }
                break
                
            case .failure(let error):
                if error is AFError {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, error._code, "Request is error!")
                    completion(nil, err)
                }
                break
            }
        }
    }
    
}
