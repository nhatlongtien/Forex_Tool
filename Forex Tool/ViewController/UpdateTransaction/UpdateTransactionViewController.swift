//
//  UpdateTransactionViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 22/07/2021.
//

import UIKit
import DropDown
import PKHUD
protocol UpdateTransactionViewControllerDelegate:class {
    func dataDidChange()
}
class UpdateTransactionViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var listStatusButton: UIButton!
    @IBOutlet weak var listResultButton: UIButton!
    @IBOutlet weak var statusTransactionLbl: UILabel!
    @IBOutlet weak var resultTransactionLbl: UILabel!
    //MARK: Dropdown
    let chooseStatusDropdown = DropDown()
    let chooseResultDropdown = DropDown()
    //
    var statusStr:String?
    var resultStr:String?
    var transactionID:String?
    let updateTransactionVM = UpdateTransactionViewModel()
    weak var delegate:UpdateTransactionViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.setupDataForUI()
        //
        self.viewModleCallBack()
        //
        DropDown.setupDefaultAppearance()
        setupDropDowns()
        
    }

    @IBAction func chooseStatusTransactionBtnWasPressed(_ sender: Any) {
        chooseStatusDropdown.show()
    }
    @IBAction func chooseResultTransactionBtnWasPressed(_ sender: Any) {
        chooseResultDropdown.show()
    }
    @IBAction func updateBtnWasPressed(_ sender: Any) {
        guard let transactionID = transactionID else {return}
        updateTransactionVM.updateTransactionByID(transactionID: transactionID, statusTransaction: statusStr!, resultTransaction: resultStr!) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
                self.delegate?.dataDidChange()
            }
        }
    }
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - Setup
    
    func setupDropDowns(){
        setupChooseStatusDropDown()
        setupChooseResultDropDown()
    }
    func setupChooseStatusDropDown(){
        chooseStatusDropdown.anchorView = listStatusButton
        chooseStatusDropdown.dataSource = [
            StatusTransaction.Active.rawValue,
            StatusTransaction.Pending.rawValue,
            StatusTransaction.Complete.rawValue
        ]
        chooseStatusDropdown.selectionAction = {[weak self] (index, item) in
            self?.statusStr = item
            self?.setupDataForUI()
        }
    }
    func setupChooseResultDropDown(){
        chooseResultDropdown.anchorView = listResultButton
        chooseResultDropdown.dataSource = [
            ResultTransaction.Win.rawValue,
            ResultTransaction.Loss.rawValue,
            ResultTransaction.Unknow.rawValue
        ]
        chooseResultDropdown.selectionAction = {[weak self] (index, item) in
            self?.resultStr = item
            if self?.resultStr?.uppercased() == ResultTransaction.Win.rawValue.uppercased() || self?.resultStr?.uppercased() == ResultTransaction.Loss.rawValue.uppercased(){
                self?.statusStr = StatusTransaction.Complete.rawValue
            }
            self?.setupDataForUI()
        }
    }
    //MaRK: - Helper Method
    func setupDataForUI(){
        self.statusTransactionLbl.text = statusStr
        self.resultTransactionLbl.text = resultStr
    }
    private func viewModleCallBack(){
        updateTransactionVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        updateTransactionVM.afterApiCall = {
            HUD.hide()
        }
    }

}



