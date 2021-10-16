//
//  ListPairCurrencyViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/07/2021.
//

import UIKit
import PKHUD
protocol ListPairCurrencyDelegate:class {
    func passPairCurrencyData(pairCurrency:PairCurrencyModel)
}
class ListPairCurrencyViewController: UIViewController {

    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    //
    let listPairCurrencyVM = ListPairCurrencyViewModel()
    var listPairCurrency:[PairCurrencyModel] = []
    var listPairCurrencySearch:[PairCurrencyModel] = []
    var currentPairCurrency:String?
    var isSearch = false
    weak var delegate:ListPairCurrencyDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "ListPairCurrencyTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ListPairCurrencyTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //
        viewModelCallBack()
        //
        searchTextField.delegate = self
        searchTextField.placeholder = "Search your pair currency".localized()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.title = "List Pair Currency".localized()
        //
        listPairCurrencyVM.getListPairCurrency { (result, listCurrency) in
            if result == true{
                guard let list = listCurrency else {return}
                self.listPairCurrency = list
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func searchButtonWasPressed(_ sender: Any) {
    }
    
    //MARK: Helper Method
    private func viewModelCallBack() {
        listPairCurrencyVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        listPairCurrencyVM.afterApiCall = {
            HUD.hide()
        }
    }
    
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension ListPairCurrencyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true{
            return listPairCurrencySearch.count
        }else{
            return listPairCurrency.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPairCurrencyTableViewCell", for: indexPath) as! ListPairCurrencyTableViewCell
        if isSearch == true{
            cell.configCell(pairCurrency: listPairCurrencySearch[indexPath.row], currentPairCurrency: self.currentPairCurrency!)
        }else{
            cell.configCell(pairCurrency: listPairCurrency[indexPath.row], currentPairCurrency: self.currentPairCurrency)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch == true{
            self.delegate?.passPairCurrencyData(pairCurrency: listPairCurrencySearch[indexPath.row])
        }else{
            self.delegate?.passPairCurrencyData(pairCurrency: listPairCurrency[indexPath.row])
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:
extension ListPairCurrencyViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == ""{
            self.isSearch = false
            tableView.reloadData()
        }else{
            listPairCurrencySearch = listPairCurrency.filter({ (pairCurrency) -> Bool in
                return (pairCurrency.name?.lowercased().contains((textField.text?.lowercased())!))!
            })
            isSearch = true
            tableView.reloadData()
        }
    }
}
