//
//  HomeNewsViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 16/09/2021.
//

import Foundation
import FeedKit
import SwiftSoup
class HomeNewsViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    func getRSSFeed(urlString:String, completionHandler:@escaping(_ listNews:[NewsItem]?) -> Void){
        let feedURL = URL(string: urlString)!
        let parser = FeedParser(URL: feedURL)
        var rssFeed:RSSFeed?
        //beforeApiCall?()
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
                        author: SourceFrom.investing.rawValue)
                    listNewsReturn.append(news)
                }
                //self.afterApiCall?()
                completionHandler(listNewsReturn)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                //self.afterApiCall?()
                completionHandler(listNewsReturn)
            }
        }
    }
    func scrapingNewsFromCoin68(){
        let url = "https://coin68.com/tin-tuc-24h/"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            let doc:Document = try SwiftSoup.parse(content)
            let newsContent = try doc.getElementsByClass("jeg_posts jeg_load_more_flag").first()!
            let articles:Elements = try newsContent.select("article")
            for eachArticle in articles{
                let postDate = try eachArticle.getElementsByClass("jeg_meta_date").first()?.text()
                let content = try eachArticle.getElementsByClass("content").first()!
                let imageElement = try content.select("img[src]").first()
                let imageUrl = try imageElement?.attr("src")
                let titleElement = try content.getElementsByClass("jeg_postblock_content").first()!
                let title = try titleElement.select("a").first()
                let titleStr = try title?.text()
                let newsLink = try title?.attr("href")
                print(titleStr)
                print(newsLink)
                print(imageUrl)
                print(postDate)
            }
        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print(error)
        }
    }
    
    func scrapingNewsFromTapChiBitcoin(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var listNewsReturn = [NewsItem]()
        let url = "https://tapchibitcoin.io/"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            let doc:Document = try SwiftSoup.parse(content)
            let articles:Elements = try doc.getElementsByClass("td-block-span12")
            for eachArticle in articles{
                let imageElement = try eachArticle.select("img[src]").first()
                let imageUrl = try imageElement?.attr("src")
                let itemDetailElement = try eachArticle.getElementsByClass("entry-title td-module-title").first()
                let titleElement = try itemDetailElement?.select("a").first()
                let titleStr = try titleElement?.text()
                let newsLink = try titleElement?.attr("href")
                let postDateEmelement = try eachArticle.getElementsByClass("entry-date updated td-module-date").first()
                let postDate = try postDateEmelement?.attr("datetime").formartDate(inputFormat: DateformatterType.YYYY_MM_DD_T_HH_mm_ssZ.rawValue)
                let modifiedDate = Calendar.current.date(byAdding: .hour, value: -7, to: postDate ?? Date())
                let news = NewsItem(imageUrl: imageUrl, title: titleStr, pubdate: modifiedDate, linkDetail: newsLink, author: SourceFrom.tapchibitcoin.rawValue)
                listNewsReturn.append(news)
            }
            completionHanler(listNewsReturn)
        }catch Exception.Error(let type, let message){
            print(message)
            completionHanler(listNewsReturn)
        }catch{
            print(error)
            completionHanler(listNewsReturn)
        }
    }
    
    func scrapingNewsFromBlogTienAo(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var listNewsReturn = [NewsItem]()
        let url = "https://blogtienao.com/tin-tuc-crypto/"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            let doc:Document = try SwiftSoup.parse(content)
            let articles:Elements = try doc.getElementsByClass("td-block-span6")
            for eachArticle in articles{
                let imageElement = try eachArticle.select("img[src]").first()
                let imageUrl = try imageElement?.attr("data-img-url")
                let itemDetailElement = try eachArticle.getElementsByClass("entry-title td-module-title").first()
                let titleElement = try itemDetailElement?.select("a").first()
                let titleStr = try titleElement?.text()
                let newsLink = try titleElement?.attr("href")
                let postDateEmelement = try eachArticle.getElementsByClass("entry-date updated td-module-date").first()
                let postDate = try postDateEmelement?.attr("datetime").formartDate(inputFormat: DateformatterType.YYYY_MM_DD_T_HH_mm_ssZ.rawValue)
                let modifiedDate = Calendar.current.date(byAdding: .hour, value: -7, to: postDate ?? Date())
                let news = NewsItem(imageUrl: imageUrl, title: titleStr, pubdate: modifiedDate, linkDetail: newsLink, author: SourceFrom.blogtienao.rawValue)
                listNewsReturn.append(news)
            }
            completionHanler(listNewsReturn)
        }catch Exception.Error(let type, let message){
            print(message)
            completionHanler(listNewsReturn)
        }catch{
            print(error)
            completionHanler(listNewsReturn)
        }
    }
    func scrapingNewsFromVIC(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var listNewsReturn = [NewsItem]()
        let url = "https://vic.news/"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            
            let doc:Document = try SwiftSoup.parse(content)
            let newsContent = try doc.getElementsByClass("penci-wrapper-data masonry penci-masonry").first()!
            let articles:Elements = try newsContent.select("article")
            for eachArticle in articles{
                let imageElement = try eachArticle.select("img[src]").first()
                let imageUrl = try imageElement?.attr("src")
                let itemDetailElement = try eachArticle.getElementsByClass("entry-title grid-title").first()
                let titleElement = try itemDetailElement?.select("a").first()
                let titleStr = try titleElement?.text()
                let newsLink = try titleElement?.attr("href")
                let postDateEmelement = try eachArticle.getElementsByClass("entry-date published").first()
                let postDate = try postDateEmelement?.attr("datetime").formartDate(inputFormat: DateformatterType.YYYY_MM_DD_T_HH_mm_ssZ.rawValue)
                let modifiedDate = Calendar.current.date(byAdding: .hour, value: -7, to: postDate ?? Date())
                let news = NewsItem(imageUrl: imageUrl, title: titleStr, pubdate: modifiedDate, linkDetail: newsLink, author: SourceFrom.vic.rawValue)
                listNewsReturn.append(news)
            }
            completionHanler(listNewsReturn)
        }catch Exception.Error(let type, let message){
            print(message)
            completionHanler(listNewsReturn)
        }catch{
            print(error)
            completionHanler(listNewsReturn)
        }
    }
    func scrapingNewsFromInvest318(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var listNewsReturn = [NewsItem]()
        let url = "https://invest318.com/tin-tuc"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            
            let doc:Document = try SwiftSoup.parse(content)
            let articles = try doc.select("article")
            for eachArticle in articles{
                let imageElement = try eachArticle.select("img[src]").first()
                let imageUrl = try imageElement?.attr("src")
                let itemDetailElement = try eachArticle.getElementsByClass("entry-title").first()
                let titleElement = try itemDetailElement?.select("a")
                let titleStr = try titleElement?.text()
                let newsLink = try titleElement?.attr("href")
                let postDate = try eachArticle.getElementsByClass("time").text()
                var newPostDate = postDate.formartDate(inputFormat: DateformatterType.DD_MM_YYYY_Slash.rawValue)
                let news = NewsItem(imageUrl: imageUrl, title: titleStr, pubdate: newPostDate, linkDetail: newsLink, author: SourceFrom.invest138.rawValue)
                listNewsReturn.append(news)
            }
            completionHanler(listNewsReturn)
        }catch Exception.Error(let type, let message){
            print(message)
            completionHanler(listNewsReturn)
        }catch{
            print(error)
            completionHanler(listNewsReturn)
        }
    }
    func scrapingNewsFromForex(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var listNewsReturn = [NewsItem]()
        let url = "https://forex.com.vn/tin-tuc-forex"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            
            let doc:Document = try SwiftSoup.parse(content)
            let contentElement = try doc.getElementsByClass("jeg_posts jeg_load_more_flag").first()
            guard let articles = try contentElement?.select("article") else {return}
            for eachArticle in articles{
                let preImageElement = try eachArticle.getElementsByClass("thumbnail-container animate-lazy size-715 ").first()
                
                let imageElement = try preImageElement!.select("img[src]").first()
                let imageUrl = try imageElement?.attr("data-src")
                let itemDetailElement = try eachArticle.getElementsByClass("jeg_postblock_content").first()
                let titleElement = try itemDetailElement?.select("a").first()
                let titleStr = try titleElement?.text()
                let newsLink = try titleElement?.attr("href")
                let postDateElement = try eachArticle.getElementsByClass("jeg_meta_date").first()
                let postDate = try postDateElement?.select("a").text().formartDate(inputFormat: DateformatterType.DD_MM_YYYY.rawValue)
                let maxDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
                if postDate! >= maxDate{
                    let news = NewsItem(imageUrl: imageUrl, title: titleStr, pubdate: postDate, linkDetail: newsLink, author: SourceFrom.forex.rawValue)
                    listNewsReturn.append(news)
                }
            }
            completionHanler(listNewsReturn)
        }catch Exception.Error(let type, let message){
            print(message)
            completionHanler(listNewsReturn)
        }catch{
            print(error)
            completionHanler(listNewsReturn)
        }
    }
    func scrapingNewsFromFinnews24(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var listNewsReturn = [NewsItem]()
        let url = "https://finnews24.com/tin-tuc-forex-hom-nay/"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            
            let doc:Document = try SwiftSoup.parse(content)
            let contentElement = try doc.getElementsByClass("widget-content feed-widget-content widget-content-Label2").first()
            guard let articles = try contentElement?.children() else {return}
            for eachArticle in articles{
                let imageElement = try eachArticle.select("img").first()
                
                var imageUrl = try imageElement?.attr("data-s")
                if imageUrl == nil || imageUrl == ""{
                    imageUrl = try imageElement?.attr("src")
                }
                let itemDetailElement = try eachArticle.getElementsByClass("item-title").first()
                let titleElement = try itemDetailElement?.select("a").first()
                let titleStr = try titleElement?.text()
                let newsLink = try titleElement?.attr("href")
                let postDateElement = try eachArticle.getElementsByClass("meta-items").first()
                let postDate = try postDateElement?.select("span").text().formartDate(inputFormat: DateformatterType.dd_MM_yyyy_HH_mm.rawValue)
                if imageUrl != nil || imageUrl != ""{
                    let news = NewsItem(imageUrl: imageUrl, title: titleStr, pubdate: postDate, linkDetail: newsLink, author: SourceFrom.finnews24.rawValue)
                    listNewsReturn.append(news)
                }
            }
            completionHanler(listNewsReturn)
            
        }catch Exception.Error(let type, let message){
            print(message)
            completionHanler(listNewsReturn)
        }catch{
            print(error)
            completionHanler(listNewsReturn)
        }
    }
    func scrapingNewsCryptoVI(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var returnListNews = [NewsItem]()
        scrapingNewsFromTapChiBitcoin { [self] listNews in
            if let listNews = listNews{
                returnListNews += listNews
            }
            //Call function scrapingNewsFromBlogTienAo
            scrapingNewsFromBlogTienAo { listNews in
                if let listNews = listNews{
                    returnListNews += listNews
                }
                //Call function scrapingNewsFromVIC
                scrapingNewsFromVIC { listNews in
                    if let listNews = listNews{
                        returnListNews += listNews
                    }
                    completionHanler(returnListNews)
                }
            }
        }
    }
    func scrapingNewsFoexVI(completionHanler:@escaping(_ listNews:[NewsItem]?) -> Void){
        var returnListNews = [NewsItem]()
        getRSSFeed(urlString: NewsLinkRSSFeed.forex.rawValue) { [self] listNews in
            if let listNews = listNews{
                returnListNews += listNews
            }
            getRSSFeed(urlString: NewsLinkRSSFeed.goods.rawValue) { listNews in
                if let listNews = listNews{
                    returnListNews += listNews
                }
                //Call function scrapingNewsFromForex
                DispatchQueue.main.async {
                    scrapingNewsFromForex { [self] listNews in
                        if let listNews = listNews{
                            returnListNews += listNews
                        }
                        //Call function scrapingNewsFromInvest318
                        scrapingNewsFromInvest318 { listNews in
                            if let listNews = listNews{
                                returnListNews += listNews
                            }
                        }
                        //Call function scrapingNewsFromFinnews24
                        scrapingNewsFromFinnews24 { listNews in
                            if let listNews = listNews{
                                returnListNews += listNews
                            }
                            completionHanler(returnListNews)
                        }
                    }
                }
            }
        }
    }
}
