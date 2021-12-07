//
//  CalendarEconomicModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/12/2021.
//

import Foundation
import SwiftUI
import SwiftyJSON
class CalendarEconomicModel{
    public private(set) var pub_time:String?
    public private(set) var country_flag:String?
    public private(set) var current_date:String?
    public private(set) var content:[Content]?
    public private(set) var pub_time_tz:String?
    public private(set) var events_translate:String?
    public private(set) var events_id:Int?
    public private(set) var comment:String?
    public private(set) var events:String?
    public private(set) var determine:String?
    public private(set) var star:String?
    
    init(json:JSON) {
        self.pub_time = json["pub_time"].stringValue
        self.country_flag = json["country_flag"].stringValue
        self.current_date = json["current_date"].stringValue
        self.pub_time_tz = json["pub_time_tz"].stringValue
        self.events_translate = json["events_translate"].stringValue
        self.events_id = json["events_id"].intValue
        self.events = json["events"].stringValue
        self.determine = json["determine"].stringValue
        self.star = json["star"].stringValue
        var contentReturn = [Content]()
        if let contents = json["content"].array{
            for item in contents{
                let content = Content(
                    id: item["id"].intValue,
                    previous: item["previous"].stringValue,
                    consensus: item["consensus"].stringValue,
                    actual: item["actual"].stringValue,
                    star: item["star"].stringValue,
                    revised: item["revised"].stringValue,
                    translate: item["translate"].stringValue,
                    influence: item["influence"].intValue,
                    economics_id: item["economics_id"].stringValue,
                    pub_time_tz: item["pub_time_tz"].stringValue)
                
                contentReturn.append(content)
            }
        }
        self.content = contentReturn
    }
    
    class Content{
        var id:Int
        var previous:String?
        var consensus:String?
        var actual:String?
        var star:String?
        var revised:String?
        var translate:String?
        var influence:Int?
        var economics_id:String?
        var pub_time_tz:String?
        init(id:Int, previous:String?, consensus:String?, actual:String?, star:String?, revised:String?, translate:String?, influence:Int?, economics_id:String?, pub_time_tz:String?) {
            self.id = id
            self.previous = previous
            self.actual = actual
            self.consensus = consensus
            self.star = star
            self.revised = revised
            self.translate = translate
            self.influence = influence
            self.economics_id = economics_id
            self.pub_time_tz = pub_time_tz
        }
    }
}
class ReverseCalendarEconomicModel{
    public private(set) var id:Int
    public private(set) var previous:String?
    public private(set) var consensus:String?
    public private(set) var actual:String?
    public private(set) var star:String?
    public private(set) var revised:String?
    public private(set) var translate:String?
    public private(set) var events_translate:String?
    public private(set) var influence:Int?
    public private(set) var economics_id:String?
    public private(set) var pub_time:String?
    public private(set) var country_flag:String?
    public private(set) var current_date:String?
    
    
    init(id:Int, previous:String?, consensus:String?, actual:String?, star:String?, revised:String?, translate:String?, influence:Int?, economics_id:String?, pub_time:String?, country_flag:String?, current_date:String?, events_translate:String?) {
        self.id = id
        self.previous = previous
        self.actual = actual
        self.consensus = consensus
        self.star = star
        self.revised = revised
        self.translate = translate
        self.influence = influence
        self.economics_id = economics_id
        self.pub_time = pub_time
        self.country_flag = country_flag
        self.current_date = current_date
        self.events_translate = events_translate
    }
}
