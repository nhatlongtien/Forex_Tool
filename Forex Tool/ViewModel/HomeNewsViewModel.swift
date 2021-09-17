//
//  HomeNewsViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 16/09/2021.
//

import Foundation
import FeedKit
class HomeNewsViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    func getRSSFeed(urlString:String, completionHandler:@escaping(_ result:Bool,_ listNews:[NewsItem]?) -> Void){
        let feedURL = URL(string: urlString)!
        let parser = FeedParser(URL: feedURL)
        var rssFeed:RSSFeed?
//        let result = parser.parse()
//        var listNewsReturn:[NewsItem] = []
//        switch result{
//        case .success(let feed):
//            rssFeed = feed.rssFeed
//            let listItems = rssFeed?.items
//            print(rssFeed?.items?.count)
//            for eachItem in listItems!{
//                let news = NewsItem(
//                    imageUrl: eachItem.enclosure?.attributes?.url,
//                    title: eachItem.title,
//                    pubdate: eachItem.pubDate,
//                    linkDetail: eachItem.link,
//                    author: eachItem.author)
//                listNewsReturn.append(news)
//            }
//            completionHandler(true, listNewsReturn)
//        case .failure(let error):
//            print("Error: \(error.localizedDescription)")
//            completionHandler(false, nil)
//        }
        beforeApiCall?()
        parser.parseAsync { [weak self] (result) in
            guard let self = self else {return}
            var listNewsReturn:[NewsItem] = []
            switch result{
            case .success(let feed):
                rssFeed = feed.rssFeed
                let listItems = rssFeed?.items
                print(rssFeed?.items?.first)
                for eachItem in listItems!{
                    let news = NewsItem(
                        imageUrl: eachItem.enclosure?.attributes?.url,
                        title: eachItem.title,
                        pubdate: eachItem.pubDate,
                        linkDetail: eachItem.link,
                        author: eachItem.author)
                    listNewsReturn.append(news)
                }
                completionHandler(true, listNewsReturn)
                self.afterApiCall?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completionHandler(false, nil)
                self.afterApiCall?()
            }
            
        }
        
    }
}
