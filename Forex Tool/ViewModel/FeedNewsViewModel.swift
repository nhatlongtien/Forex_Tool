//
//  FeedNewsViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 26/11/2021.
//

import Foundation
import SwiftSoup
class FeedNewsViewModel{
    var beforeApiCall:(() -> Void)?
    var afterApiCall : (() -> Void)?
    func scrapingHotNewsForex(CompletionHandler:@escaping(_ result:Bool,_ listNews:[HotNews247Model]?) -> Void){
        beforeApiCall?()
        var listHotNews = [HotNews247Model]()
        let url = "https://invest318.com/diem-tin"
        do{
            let content = try String(contentsOf: URL(string: url)!)
            
            let doc:Document = try SwiftSoup.parse(content)
            let nomalHotNews = try doc.getElementsByClass("custom-new-box d-flex")
            let calendarHotNews = try doc.getElementsByClass("custom-calendar d-flex")
            for eachNomalHotNews in nomalHotNews{
                let rawPostTime = try eachNomalHotNews.getElementsByClass("Bahnschrift").text().formartDate(inputFormat: DateformatterType.HH_mm_ss.rawValue)
                let postTime = Calendar.current.date(byAdding: .hour, value: 0, to: rawPostTime)
                let content = try eachNomalHotNews.getElementsByClass("custom-new-box-content-content ").text()
                
                if Calendar.current.component(.hour, from: rawPostTime) <= Calendar.current.component(.hour, from: Date()){
                    let hotNews = HotNews247Model(postTime: postTime, content: content, value: nil, impactNews: nil, flagImageUrl: nil)
                    listHotNews.append(hotNews)
                }else{
                    break
                }
            }
            for eachCalendarHotNews in calendarHotNews{
                var impactNews:String?
                var value:String?
                let postTimeElement = try eachCalendarHotNews.getElementsByClass("custom-calendar-time d-flex")
                let rawPostTime = try postTimeElement.select("span").text().formartDate(inputFormat: DateformatterType.HH_mm_ss.rawValue)
                let postTime = Calendar.current.date(byAdding: .hour, value: 0, to: rawPostTime)
                let content = try eachCalendarHotNews.getElementsByClass("custom-calendar-container-top-title").text()
                let flagImageElement = try eachCalendarHotNews.select("img[src]").first()
                let flagImageUrl = try flagImageElement?.attr("src")
                if let goodNews = try eachCalendarHotNews.getElementsByClass("custom-calendar-container-top-right Bahnschrift d-md-block d-none  rise  ").first(){
                    value = try goodNews.select("span").text()
                    impactNews = "good_news"
                }
                if let badNews = try eachCalendarHotNews.getElementsByClass("custom-calendar-container-top-right Bahnschrift d-md-block d-none  fail ").first(){
                    value = try badNews.select("span").text()
                    impactNews = "bad_news"
                }
                if let neutralNews = try eachCalendarHotNews.getElementsByClass("custom-calendar-container-top-right Bahnschrift d-md-block d-none ").first(){
                    value = try neutralNews.select("span").text()
                    impactNews = "neutral_news"
                }
                
                if Calendar.current.component(.hour, from: rawPostTime) <= Calendar.current.component(.hour, from: Date()){
                    let hotNews = HotNews247Model(postTime: postTime, content: content, value: value, impactNews: impactNews, flagImageUrl: flagImageUrl)
                    listHotNews.append(hotNews)
                }else{
                    break
                }
                
            }
            let rearrangeListHotNews = listHotNews.sorted(by: {$0.postTime! > $1.postTime!})
            for eachItem in rearrangeListHotNews {
                print(eachItem.postTime)
                print(eachItem.content)
                print(eachItem.impactNews)
                print(eachItem.value)
                print(eachItem.flagImageUrl)
                print("--------------------------")
            }
            CompletionHandler(true, rearrangeListHotNews)
            self.afterApiCall?()
        }catch Exception.Error(let type, let message){
            print(message)
            CompletionHandler(false, nil)
            self.afterApiCall?()
        }catch{
            print(error)
            CompletionHandler(false, nil)
            self.afterApiCall?()
        }
    }
}
