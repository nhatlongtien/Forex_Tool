//
//  Feed247NewsModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 02/12/2021.
//

import Foundation
import SwiftyJSON
class Feed247NewsModel{
    public private(set) var id:Int
    public private(set) var translate:String?
    public private(set) var type:String?
    public private(set) var important:String?
    public private(set) var star:String?
    public private(set) var actual:String?
    public private(set) var previous:String?
    public private(set) var consensus:String?
    public private(set) var revised:String?
    public private(set) var time:String?
    public private(set) var country:String?
    public private(set) var category:String?
    public private(set) var information_id:String?
    public private(set) var content:String?
    public private(set) var influence:String?
    public private(set) var country_flag:String?
    public private(set) var is_link:Int?
    public private(set) var article_id:String?
    public private(set) var attr_json:lang
    
    init(json:JSON) {
        self.id = json["id"].intValue
        self.translate = json["translate"].stringValue
        self.type = json["type"].stringValue
        self.important = json["important"].stringValue
        self.star = json["star"].stringValue
        self.actual = json["actual"].stringValue
        self.previous = json["previous"].stringValue
        self.consensus = json["consensus"].stringValue
        self.revised = json["revised"].stringValue
        self.time = json["time"].stringValue
        self.country = json["country"].stringValue
        self.category = json["category"].stringValue
        self.information_id = json["information_id"].stringValue
        self.content = json["content"].stringValue
        self.influence = json["influence"].stringValue
        self.country_flag = json["country_flag"].stringValue
        self.is_link = json["is_link"].intValue
        self.article_id = json["article_id"].stringValue
        self.attr_json = lang(th: json["attr_json"]["lang"]["th"].stringValue, vi: json["attr_json"]["lang"]["vi"].stringValue)
    }
    
    
    class lang{
        var th:String?
        var vi:String?
        
        init(th:String?, vi:String?) {
            self.th = th
            self.vi = vi
        }
    }
}
