//
//  ManageTransactionViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/07/2021.
//

import UIKit
import PKHUD
class ManageTransactionViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    //
    let dashboardVM = DashboardViewModel()
    var listTransaction:[TransactionModel] = []
    var filterObject:FilterObjectModel = FilterObjectModel(isFilter: false, fromDate: nil, toDate: nil, statusTransaction: nil, resultTransaction: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.viewModelCallBack()
        //
        let nibCell = UINib(nibName: "ManagerTransactionTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "ManagerTransactionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//        self.title = "Manager Transaction"
        if Constant.isInTabBarControll == true{
            self.navigationController?.navigationBar.isHidden = true
            Constant.isInTabBarControll = false
        }else{
            self.navigationController?.navigationBar.isHidden = false
            self.title = "Manager Transaction"
        }
        //
        self.callAPIToGetListTransaction(filterObject: self.filterObject)
    }
    //MARK: Helper Method
    func callAPIToDeleteTransaction(transaction:TransactionModel){
        guard let transactionID = transaction.transactionID else {return}
        dashboardVM.deleteTransactionByID(transactionID: transactionID) { (success) in
            if success{
                //Call API to load list transaction
                self.callAPIToGetListTransaction(filterObject: self.filterObject)
            }
        }
    }
    func callAPIToGetListTransaction(filterObject:FilterObjectModel){
        dashboardVM.getListTransaction(isFillter: filterObject.isFilter!, fromDate: filterObject.fromDate, toDate: filterObject.toDate, statusTransaction: filterObject.statusTransaction, resultTransaction: filterObject.resultTransaction) { (succsess, response) in
            if succsess{
                print(response?.count)
                self.listTransaction = []
                guard let list = response else {return}
                self.listTransaction = list
                self.tableView.reloadData()
            }
        }
    }
    private func viewModelCallBack(){
        dashboardVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        dashboardVM.afterApiCall = {
            HUD.hide()
        }
    }

}
extension ManageTransactionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTransaction.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerTransactionTableViewCell", for: indexPath) as! ManagerTransactionTableViewCell
        cell.configureCell(transaction: listTransaction[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: ManagerTransactionTableViewCellDelegate
extension ManageTransactionViewController: ManagerTransactionTableViewCellDelegate{
    func deleteTransactionButtonDidTap(transaction: TransactionModel) {
        print("Delete Cell")
        let alert = UIAlertController(title: "Alert", message: "Do you want to delete this transaction", preferredStyle: .alert)
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let btnOK = UIAlertAction(title: "OK", style: .default) { (action) in
            //Call API to delete transaction
            self.callAPIToDeleteTransaction(transaction: transaction)
        }
        alert.addAction(btnCancel)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editTransactionButtonDitTap(transaction: TransactionModel) {
        print("Edit Cell")
//        let targetVC = CreateTransactionViewController()
//        targetVC.selectedTransaction = transaction
//        targetVC.isEdit = true
//        self.navigationController?.pushViewController(targetVC, animated: true)
        let targetVC = UpdateTransactionViewController()
        targetVC.statusStr = transaction.status
        targetVC.resultStr = transaction.detail?.result
        targetVC.transactionID = transaction.transactionID
        targetVC.delegate = self
        targetVC.modalPresentationStyle = .custom
        self.present(targetVC, animated: true, completion: nil)
    }
    
    
}
// MARK:
extension ManageTransactionViewController:UpdateTransactionViewControllerDelegate{
    func dataDidChange() {
        self.callAPIToGetListTransaction(filterObject: self.filterObject)
    }
    
    
}
