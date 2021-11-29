//
//  HotNews247Model.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 26/11/2021.
//

import Foundation
class HotNews247Model{
    var postTime:Date?
    var content:String?
    var value:String?
    var impactNews:String?
    var flagImageUrl:String?
    
    init(postTime:Date?, content:String?, value:String?, impactNews:String?, flagImageUrl:String?) {
        self.postTime = postTime
        self.content = content
        self.value = value
        self.impactNews = impactNews
        self.flagImageUrl = flagImageUrl
    }
}
