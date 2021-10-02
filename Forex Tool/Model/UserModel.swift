//
//  UserModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 09/07/2021.
//

import Foundation
import SwiftyJSON
class UserModel{
    public  private(set) var fullName:String?
    public private(set) var email:String?
    public private(set) var phoneNumber:String?
    public private(set) var address:String?
    public private(set) var uid:String?
    public private(set) var avatarImg:String?
    public private(set) var methodLogin:String?
    public private(set) var password:String?
    public private(set) var documentID:String?
    public private(set) var dateOfBirth:String?
    
    init(json:JSON, documentID:String?) {
        self.fullName = json["fullName"].stringValue
        self.email = json["email"].stringValue
        self.phoneNumber = json["phoneNumber"].stringValue
        self.address = json["address"].stringValue
        self.uid = json["uid"].stringValue
        self.avatarImg = json["avatarImg"].stringValue
        self.methodLogin = json["methodLogin"].stringValue
        self.documentID = documentID
        self.dateOfBirth = json["dateOfBirth"].stringValue
    }
}
