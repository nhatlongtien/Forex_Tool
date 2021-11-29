//
//  HomeNewsViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/09/2021.
//

import UIKit
import Kingfisher
import PKHUD
import SkeletonView
class HomeNewsViewController: BaseViewController {

    @IBOutlet weak var tabNewsCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let headerView = NewsHeaderView()
    let homeNewsVM = HomeNewsViewModel()
    var listNews:[NewsItem] = []
    var titleString:String? = Constant.listTabNews.first
    var newsLinkRSSFeed:String?
    var isFromTabbar:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.viewModelCallBack()
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        tabNewsCollection.collectionViewLayout = layout
        let nibTabCell = UINib(nibName: "TypeNewCollectionViewCell", bundle: nil)
        tabNewsCollection.register(nibTabCell, forCellWithReuseIdentifier: "TypeNewCollectionViewCell")
        tabNewsCollection.delegate = self
        tabNewsCollection.dataSource = self
        //Select the first item 
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        tabNewsCollection?.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        //
        let nibTableViewCell = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nibTableViewCell, forCellReuseIdentifier: "NewsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //
        headerView.delegate = self
        //
        let currentLanguage = Locale.preferredLanguages[0] as String
        if currentLanguage == "vi" || currentLanguage == "vi-VN"{
            HUD.show(.systemActivity)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.homeNewsVM.scrapingNewsFoexVI { listNews in
                    guard let news = listNews else {return}
                    self.listNews = []
                    self.listNews = news.sorted(by: {$0.pubdate! > $1.pubdate!})
                    if let item = self.listNews.first{
                        self.headerView.configView(item: item)
                    }
                    self.tableView.reloadData()
                    HUD.hide()
                }
            }

        }else{
            HUD.show(.systemActivity)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.homeNewsVM.scrapingNewsFoexVI { listNews in
                    guard let news = listNews else {return}
                    self.listNews = []
                    self.listNews = news.sorted(by: {$0.pubdate! > $1.pubdate!})
                    if let item = self.listNews.first{
                        self.headerView.configView(item: item)
                    }
                    self.tableView.reloadData()
                    HUD.hide()
                }
            }
        }
                
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        if isFromTabbar == false{
            self.navigationController?.navigationBar.isHidden = false
            self.title = "Economic News".localized()
        }

    }
    //MARK: Helper Method
    func getListNews(url:String){
        self.homeNewsVM.getRSSFeed(urlString: url) { ( listNews) in
            guard let news = listNews else {return}
            self.listNews = []
            self.listNews = news
            DispatchQueue.main.async {
                if let item = self.listNews.first{
                    self.headerView.configView(item: item)
                }
                self.tableView.reloadData()
            }
        }
    }
    func viewModelCallBack(){
        homeNewsVM.beforeApiCall = {
            DispatchQueue.main.async {
                HUD.show(.systemActivity)
            }
            
        }
        homeNewsVM.afterApiCall = {
            DispatchQueue.main.async {
                HUD.hide()
            }
            
        }
    }

}
//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension HomeNewsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.listTabNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabNewsCollection.dequeueReusableCell(withReuseIdentifier: "TypeNewCollectionViewCell", for: indexPath) as! TypeNewCollectionViewCell
        cell.configCell(item: Constant.listTabNews[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Update width for cell
        let size = CGSize(width: 1000, height: 50)
        let estimateFrame = NSString(string: Constant.listTabNews[indexPath.row]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 16)], context: nil)
        let width = estimateFrame.width + 40
        return CGSize(width: width, height: 50)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentLanguage = Locale.preferredLanguages[0] as String
        if currentLanguage == "vi" || currentLanguage == "vi-VN"{
            switch indexPath.row {
            case 0:
                HUD.show(.systemActivity)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.homeNewsVM.scrapingNewsFoexVI { listNews in
                        guard let news = listNews else {return}
                        self.listNews = []
                        self.listNews = news.sorted(by: {$0.pubdate! > $1.pubdate!})
                        if let item = self.listNews.first{
                            self.headerView.configView(item: item)
                        }
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                }
            case 1:
                //self.getListNews(url: NewsLinkRSSFeed.crypto.rawValue)
                HUD.show(.systemActivity)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.homeNewsVM.scrapingNewsCryptoVI { listNews in
                        guard let news = listNews else {return}
                        self.listNews = []
                        self.listNews = news.sorted(by: {$0.pubdate! > $1.pubdate!})
                        if let item = self.listNews.first{
                            self.headerView.configView(item: item)
                        }
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                }
            case 2:
                //self.getListNews(url: NewsLinkRSSFeed.forex.rawValue)
                self.getListNews(url: NewsLinkRSSFeed.stock.rawValue)
            default:
                break
            }
        }else{ //Tieng Anh
            switch indexPath.row {
            case 0:
                HUD.show(.systemActivity)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.homeNewsVM.scrapingNewsFoexVI { listNews in
                        guard let news = listNews else {return}
                        self.listNews = []
                        self.listNews = news.sorted(by: {$0.pubdate! > $1.pubdate!})
                        if let item = self.listNews.first{
                            self.headerView.configView(item: item)
                        }
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                }
            case 1:
                //self.getListNews(url: NewsLinkRSSFeed.crypto.rawValue)
                HUD.show(.systemActivity)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.homeNewsVM.scrapingNewsCryptoVI { listNews in
                        guard let news = listNews else {return}
                        self.listNews = []
                        self.listNews = news.sorted(by: {$0.pubdate! > $1.pubdate!})
                        if let item = self.listNews.first{
                            self.headerView.configView(item: item)
                        }
                        self.tableView.reloadData()
                        HUD.hide()
                    }
                }
            case 2:
                //self.getListNews(url: NewsLinkRSSFeed.forex.rawValue)
                self.getListNews(url: NewsLinkRSSFeed.stock.rawValue)
            default:
                break
            }
        }
        self.titleString = Constant.listTabNews[indexPath.row]
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension HomeNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNews.count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.configCell(item: listNews[indexPath.row + 1])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetVC = DetailNewsViewController()
        targetVC.selectedNewsItem = listNews[indexPath.row + 1]
        targetVC.titleScreen = self.titleString
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        print(listNews.count)
        //
        let size = CGSize(width: self.view.frame.width - 30, height: 1000)
        let estimateFrame = NSString(string: headerView.titleLbl.text!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 15)], context: nil)
        let height = 234.5 + estimateFrame.height
        print(estimateFrame.height)
        print(estimateFrame.width)
        return height
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
//MARK: NewsHeaderViewDelegate
extension HomeNewsViewController:NewsHeaderViewDelegate{
    func didTapContentView() {
        let targetVC = DetailNewsViewController()
        targetVC.selectedNewsItem = listNews.first
        targetVC.titleScreen = self.titleString
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
