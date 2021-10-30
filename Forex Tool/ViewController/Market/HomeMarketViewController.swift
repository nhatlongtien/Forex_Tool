//
//  HomeMarketViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 04/10/2021.
//

import UIKit
import PKHUD
class HomeMarketViewController: BaseViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    //
    let homeMarketVM = HomeMarketViewModel()
    var listInfoPairCurrecy:[PricePairCurrencyModel] = []
    //
    var isSearch = false
    var listInfoPairCurrencySearch:[PricePairCurrencyModel] = []
    var isFromTabbar:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModelCallBack()
        searchTextField.delegate = self
        searchTextField.placeholder = "Search your pair currency".localized()
        //
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        let nibCell = UINib(nibName: "HomeMarketCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "HomeMarketCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if isFromTabbar == false{
            self.navigationController?.navigationBar.isHidden = false
            self.title = "Market".localized()
        }
        //
        homeMarketVM.infoPairCurrency(symbol: Constant.SymbolMarket) { success, listInfoPairCurrency in
            if success{
                guard let list = listInfoPairCurrency else {return}
                self.listInfoPairCurrecy = []
                self.listInfoPairCurrecy = list
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func searchButtonWasPressed(_ sender: Any) {
    
    }
    //MARK: Helper Method
    func viewModelCallBack(){
        homeMarketVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        homeMarketVM.afterApiCall = {
            HUD.hide()
        }
    }
}
//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension HomeMarketViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch == false{
            return self.listInfoPairCurrecy.count
        }else{
            return self.listInfoPairCurrencySearch.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMarketCollectionViewCell", for: indexPath) as! HomeMarketCollectionViewCell
        if isSearch == false{
            cell.configCell(item: listInfoPairCurrecy[indexPath.row])
        }else{
            cell.configCell(item: listInfoPairCurrencySearch[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width - 20 - 20 - 15)/2, height: 155)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetVC = DetailMarketViewController()
        if isSearch == true{
            targetVC.infoPairCurrency = listInfoPairCurrencySearch[indexPath.row]
        }else{
            targetVC.infoPairCurrency = listInfoPairCurrecy[indexPath.row]
        }
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
//MARK:
extension HomeMarketViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == ""{
            self.isSearch = false
            collectionView.reloadData()
        }else{
            listInfoPairCurrencySearch = listInfoPairCurrecy.filter({(pairCurrency) -> Bool in
                return (pairCurrency.symbol?.uppercased().contains((textField.text?.uppercased())!))!
            })
            isSearch = true
            collectionView.reloadData()
        }
    }
}
