//
//  NewsModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 16/09/2021.
//

import Foundation
struct NewsItem:Hashable{
    public private(set) var imageUrl:String?
    public private(set) var title:String?
    public private(set) var pubdate:Date?
    public private(set) var linkDetail:String?
    public private(set) var author:String?
}
