//
//  NotificationModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/10/2021.
//

import Foundation
import SwiftyJSON
struct NotificationModel{
    public private(set) var title:String?
    public private(set) var body:String?
    public private(set) var urlMedia:String?
    public private(set) var date:String?
    init(json:JSON) {
        self.title = json["title"].stringValue
        self.body = json["body"].stringValue
        self.urlMedia = json["urlMedia"].stringValue
        self.date = json["dateCreate"].stringValue
    }
}
