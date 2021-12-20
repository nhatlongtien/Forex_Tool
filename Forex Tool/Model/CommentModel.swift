//
//  CommentModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 12/12/2021.
//

import Foundation
import SwiftyJSON
class CommentModel{
    public private(set) var messTxt:String?
    public private(set) var userID:String?
    public private(set) var mediaUrl:String?
    public private(set) var fileUrl:String?
    public private(set) var pubdate:String?
    
    init(json:JSON) {
        self.messTxt = json["messTxt"].stringValue
        self.userID = json["userID"].stringValue
        self.mediaUrl = json["mediaUrl"].stringValue
        self.fileUrl = json["fileUrl"].stringValue
        self.pubdate = json["pubdate"].stringValue
    }
}
