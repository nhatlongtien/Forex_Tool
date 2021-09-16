//
//  HomeNewsViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/09/2021.
//

import UIKit

class HomeNewsViewController: UIViewController {

    @IBOutlet weak var tabNewsCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.title = "News"
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        // Resize header view with dynamic size in UITableView
//        guard let headerView = tableView.tableHeaderView else {
//            return
//        }
//        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        if headerView.frame.height != size.height {
//            tableView.tableHeaderView?.frame = CGRect(
//                origin: headerView.frame.origin,
//                size: size
//            )
//            tableView.layoutIfNeeded()
//        }
//    }

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
        let estimateFrame = NSString(string: Constant.listTabNews[indexPath.row]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 14)], context: nil)
        let width = estimateFrame.width + 40
        return CGSize(width: width, height: 50)
        
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension HomeNewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = NewsHeaderView()
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerView = NewsHeaderView()
        let size = CGSize(width: self.view.frame.width - 30, height: 1000)
        let estimateFrame = NSString(string: headerView.titleLbl.text!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 15)], context: nil)
        let height = 234.5 + estimateFrame.height
        print(estimateFrame.height)
        print(estimateFrame.width)
        return height
        
    }
    
}
