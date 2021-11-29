//
//  AnalysisViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 10/10/2021.
//

import UIKit
import PKHUD
class AnalysisViewController: BaseViewController {
    //
    @IBOutlet weak var tabNewsCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let homeNewsVM = HomeNewsViewModel()
    var listAnalysis:[NewsItem] = []
    var selectedTabTitle = Constant.listTabAnalysisItems.first
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        viewModelCallBack()
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
        let nibCell = UINib(nibName: "AnalysisTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "AnalysisTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //
        let currentLanguage = Locale.preferredLanguages[0] as String
        if currentLanguage == "vi" || currentLanguage == "vi-VN"{
            let links = [
                "https://vn.investing.com/rss/forex_Technical.rss",
                "https://vn.investing.com/rss/forex_Fundamental.rss",
                "https://vn.investing.com/rss/forex_Opinion.rss",
                "https://vn.investing.com/rss/forex_Signals.rss"]
            getListItemForex(links: links)
        }else{
            let links = [
                "https://www.investing.com/rss/forex_Technical.rss",
                "https://www.investing.com/rss/forex_Fundamental.rss",
                "https://www.investing.com/rss/forex_Opinion.rss",
                "https://www.investing.com/rss/forex_Signals.rss"]
            getListItemForex(links: links)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Analysis & Opinion".localized()
    }
    //MARK: Helper Method
    func getListItemForex(links:[String]){
        self.listAnalysis = []
        for link in links {
            self.homeNewsVM.getRSSFeed(urlString: link) { [self] listNews in
                if let listNews = listNews {
                    listAnalysis += listNews
                    let set = Set(listAnalysis)
                    listAnalysis = Array(set)
                    listAnalysis = listAnalysis.sorted(by: { $0.pubdate! > $1.pubdate!})
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                    print(listAnalysis.count)
                }
            }
        }
    }
    //
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
extension AnalysisViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.listTabAnalysisItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabNewsCollection.dequeueReusableCell(withReuseIdentifier: "TypeNewCollectionViewCell", for: indexPath) as! TypeNewCollectionViewCell
        cell.configCell(item: Constant.listTabAnalysisItems[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentLanguage = Locale.preferredLanguages[0] as String
        if currentLanguage == "vi" || currentLanguage == "vi-VN"{
            switch indexPath.row {
            case 0:
                let links = [
                    "https://vn.investing.com/rss/forex_Technical.rss",
                    "https://vn.investing.com/rss/forex_Fundamental.rss",
                    "https://vn.investing.com/rss/forex_Opinion.rss",
                    "https://vn.investing.com/rss/forex_Signals.rss"]
                getListItemForex(links: links)
            case 1:
                let links = [
                    "https://vn.investing.com/rss/stock_Technical.rss",
                    "https://vn.investing.com/rss/stock_Fundamental.rss",
                    "https://vn.investing.com/rss/stock_Opinion.rss",
                    "https://vn.investing.com/rss/stock_stock_picks.rss",
                    "https://vn.investing.com/rss/stock_Stocks.rss",
                    "https://vn.investing.com/rss/stock_Indices.rss",
                    "https://vn.investing.com/rss/stock_Futures.rss",
                    "https://vn.investing.com/rss/stock_Options.rss"]
                getListItemForex(links: links)
            case 2:
                let links = [
                    "https://vn.investing.com/rss/commodities_Technical.rss",
                    "https://vn.investing.com/rss/commodities_Fundamental.rss",
                    "https://vn.investing.com/rss/commodities_Opinion.rss",
                    "https://vn.investing.com/rss/commodities_Strategy.rss",
                    "https://vn.investing.com/rss/commodities_Metals.rss",
                    "https://vn.investing.com/rss/commodities_Energy.rss",
                    "https://vn.investing.com/rss/commodities_Agriculture.rss"]
                getListItemForex(links: links)
            default:
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                let links = [
                    "https://www.investing.com/rss/forex_Technical.rss",
                    "https://www.investing.com/rss/forex_Fundamental.rss",
                    "https://www.investing.com/rss/forex_Opinion.rss",
                    "https://www.investing.com/rss/forex_Signals.rss"]
                getListItemForex(links: links)
            case 1:
                let links = [
                    "https://www.investing.com/rss/stock_Technical.rss",
                    "https://www.investing.com/rss/stock_Fundamental.rss",
                    "https://www.investing.com/rss/stock_Opinion.rss",
                    "https://www.investing.com/rss/stock_stock_picks.rss",
                    "https://www.investing.com/rss/stock_Stocks.rss",
                    "https://www.investing.com/rss/stock_Indices.rss",
                    "https://www.investing.com/rss/stock_Futures.rss",
                    "https://www.investing.com/rss/stock_ETFs.rss",
                    "https://www.investing.com/rss/stock_Options.rss"]
                getListItemForex(links: links)
            case 2:
                let links = [
                    "https://www.investing.com/rss/commodities_Technical.rss",
                    "https://www.investing.com/rss/commodities_Fundamental.rss",
                    "https://www.investing.com/rss/commodities_Opinion.rss",
                    "https://www.investing.com/rss/commodities_Strategy.rss",
                    "https://www.investing.com/rss/commodities_Metals.rss",
                    "https://www.investing.com/rss/commodities_Energy.rss",
                    "https://www.investing.com/rss/commodities_Agriculture.rss"]
                getListItemForex(links: links)
            default:
                break
            }
        }
        
        self.selectedTabTitle = Constant.listTabAnalysisItems[indexPath.row]
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Update width for cell
        let size = CGSize(width: 1000, height: 50)
        let estimateFrame = NSString(string: Constant.listTabAnalysisItems[indexPath.row]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 16)], context: nil)
        let width = estimateFrame.width + 40
        return CGSize(width: width, height: 50)
    }
}
//MARK:
extension AnalysisViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAnalysis.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listAnalysis.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisTableViewCell", for: indexPath) as! AnalysisTableViewCell
            cell.configCell(item: listAnalysis[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listAnalysis.count > 0{
            let size = CGSize(width: self.view.frame.width - 30, height: 1000)
            let estimateFrame = NSString(string: listAnalysis[indexPath.row].title ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 16)], context: nil)
            let height = 55.5 + estimateFrame.height
            return height
        }else{
            return 72
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetVC = DetailNewsViewController()
        targetVC.selectedNewsItem = listAnalysis[indexPath.row]
        targetVC.titleScreen = self.selectedTabTitle
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
