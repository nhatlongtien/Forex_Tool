//
//  BaseResponse.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 29/10/2021.
//

import Foundation
import SwiftyJSON
class BaseResponse{
    var status:String?
    var code:Int?
    var msg:String?
    var response:JSON?
    init(json:JSON) {
        self.status = json["status"].stringValue
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.response = json["response"]
    }
    func isSuccessCode() -> Bool?{
        return code == 200
    }
    
}
class BaseResponseFor247Feed{
    var code:Int?
    var msg:String?
    var data:JSON?
    init(json:JSON) {
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.data = json["data"]
    }
    func isSuccessCode() -> Bool?{
        return code == 200
    }
    
}
class BaseResponseError{
    var mErrorType: NetworkErrorType!
    var mErrorCode: Int!
    var mErrorMessage: String!
    
    init(_ errorType: NetworkErrorType,_ errorCode: Int,_ errorMessage: String) {
        mErrorType = errorType
        mErrorCode = errorCode
        mErrorMessage = errorMessage
    }
}
