//
//  UserModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 09/07/2021.
//

import Foundation
class UserModel{
    public  private(set) var fullName:String?
    public private(set) var email:String?
    public private(set) var phoneNumber:String?
    public private(set) var address:String?
    public private(set) var uid:String?
    
    init(fullName:String?, email:String?, phoneNumber:String?, address:String?, uid:String?) {
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.uid = uid
    }
}
