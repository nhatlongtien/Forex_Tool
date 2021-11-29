//
//  FeedNews247ViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 26/11/2021.
//

import UIKit
import PKHUD
import SkeletonView
class FeedNews247ViewController: BaseViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var feedTableView: UITableView!
    let refreshControl = UIRefreshControl()
    var customRefreshView = UIView()
    //
    let feedNewsVM = FeedNewsViewModel()
    var listFeedNews = [HotNews247Model]()
    var isFromTabbar:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: "FeedNewsTableViewCell", bundle: nil)
        let nibCalendarCell = UINib(nibName: "FeedNewsCalendarTableViewCell", bundle: nil)
        feedTableView.register(nibCell, forCellReuseIdentifier: "FeedNewsTableViewCell")
        feedTableView.register(nibCalendarCell, forCellReuseIdentifier: "FeedNewsCalendarTableViewCell")
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        refreshControl.addSubview(customRefreshView)
        if #available(iOS 10.0, *) {
            self.feedTableView.refreshControl = refreshControl
        } else {
            self.feedTableView.addSubview(refreshControl)
        }
        //
        viewModelCallBack()
        //
        dateLbl.text = Date().dateToString(format: DateformatterType.DD_MM_YYYY.rawValue)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if isFromTabbar == false{
            self.navigationController?.navigationBar.isHidden = false
            self.title = "24/7 Feeds"
        }
        //
        HUD.show(.systemActivity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.feedNewsVM.scrapingHotNewsForex { success, listNews in
                if success{
                    guard let list = listNews else {return}
                    self.listFeedNews = list
                    self.feedTableView.reloadData()
                    HUD.hide()
                }
            }
        }
        
    }
    //MARK: Helper Method
    func viewModelCallBack(){
        feedNewsVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        feedNewsVM.afterApiCall = {
            HUD.hide()
        }
    }
    @objc func updateData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.feedNewsVM.scrapingHotNewsForex { success, listNews in
                if success{
                    guard let list = listNews else {return}
                    self.listFeedNews = []
                    self.listFeedNews = list
                    self.feedTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

}
//MARK: UITableViewDelegate, UITableViewDataSource
extension FeedNews247ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFeedNews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feedNewsItem = listFeedNews[indexPath.row]
       
        if feedNewsItem.impactNews == nil || feedNewsItem.impactNews == ""{
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedNewsTableViewCell", for: indexPath) as! FeedNewsTableViewCell
            cell.configCell(item: feedNewsItem)
            return cell
        }else{
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedNewsCalendarTableViewCell", for: indexPath) as! FeedNewsCalendarTableViewCell
            cell.configCell(item: feedNewsItem)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGSize(width: self.view.frame.width - 55, height: 1000)
        let feedNewsItem = listFeedNews[indexPath.row]
        
        if feedNewsItem.impactNews == nil || feedNewsItem.impactNews == ""{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            let estimateFrame = NSString(string: feedNewsItem.content ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [
                NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 12),
                NSAttributedString.Key.paragraphStyle:paragraphStyle
            ], context: nil)
            let height = 40 + estimateFrame.height
            return height
        }else{
            return 88
        }
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
extension FeedNews247ViewController:SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
            return "FeedNewsTableViewCell"
        }
}
