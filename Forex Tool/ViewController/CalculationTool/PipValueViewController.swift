//
//  PipValueViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 29/09/2021.
//

import UIKit
import PKHUD
class PipValueViewController: BaseViewController {

    @IBOutlet weak var positionSizeTf: UITextField!
    @IBOutlet weak var pipValueLbl: UILabel!
    @IBOutlet weak var pairCurrencyNameLbl: UILabel!
    //
    let createTransactionVM = CreateTransactionViewModel()
    let listPairCurrencyVM = ListPairCurrencyViewModel()
    var pairCurrency:PairCurrencyModel?
    var valueOfPip:Double = 0.0
    var mainPrice:Double = 0.0
    var subPrice:Double = 0.0
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModelCallBack()
        //
        positionSizeTf.delegate = self
        positionSizeTf.keyboardType = .decimalPad
        //
        self.callAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Pip Value"
        //
        //self.callAPI()
    }
    @IBAction func listPairCurrencyButtonWasPressed(_ sender: Any) {
        let targetVC = ListPairCurrencyViewController()
        targetVC.currentPairCurrency = self.pairCurrency?.name
        targetVC.delegate = self
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func calculateButtonWasPressed(_ sender: Any) {
        self.view.endEditing(true)
        guard let pairCurrency = self.pairCurrency else {return}
        let volume = Double((positionSizeTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        self.calculationPipValue(pairCurrency: pairCurrency, volume: volume)
    }
    //MARK: Helper Method
    func callAPI(){
        //Goi API lay danh sach tien te -> goi API lay gia hien tai
        listPairCurrencyVM.getListPairCurrency { (result, listPairCurrency) in
            if result == true{
                guard let list = listPairCurrency else {return}
                self.pairCurrency = list.first
                self.pairCurrencyNameLbl.text = list.first?.name
                //Goi API lay main price -> call API get sub price
                self.getMainPrice(pairCurrency: self.pairCurrency!) { success in
                    if success{
                        print("Get main price success")
                    }
                }
                self.getSubPrice(pairCurrency: self.pairCurrency!) { success in
                    if success{
                        print("Get sub price success")
                    }
                }
            }
        }
    }
    func getMainPrice(pairCurrency:PairCurrencyModel, completionHandler:@escaping(_ result:Bool) -> Void){
        createTransactionVM.getLatestPriceOfPairCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: pairCurrency.toCurrency!) { success, pricePairCurrency in
            if success{
                guard let pricePairCurrency = pricePairCurrency else {return}
                self.mainPrice = Double(pricePairCurrency.currentPrice!) ?? 0.0
                completionHandler(true)
            }else{
                completionHandler(false)
            }
        }
    }
    func getSubPrice(pairCurrency:PairCurrencyModel, completionHandler:@escaping(_ result:Bool) -> Void){
        switch pairCurrency.group {
        case "XXX_XXX": //Chi tinh subprice cho nhung cap tien cheo khong co usd
            //goi API lay ti gia phu
            switch pairCurrency.name {
            case "USDCAD", "USDCHF", "USDCZK", "USDDKK", "USDHUF", "USDJPY", "USDMXN", "USDNOK", "USDPLN", "USDSEK", "USDSGD", "USDTRY", "USDZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD:
                createTransactionVM.getLatestPriceOfPairCurrency(fromCurrency: "USD", toCurrency: pairCurrency.fromCurrency!) { success, pricePairCurrency in
                    if success{
                        guard let pricePairCurrency = pricePairCurrency else {return}
                        self.subPrice = Double(pricePairCurrency.currentPrice!) ?? 0.0
                        completionHandler(true)
                    }else{
                        completionHandler(false)
                    }
                }
            default: //1 pip = [(0.0001/tỷ giá chính)*tỷ giá phụ] USD
                createTransactionVM.getLatestPriceOfPairCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: "USD") { success, pricePairCurrency in
                    if success{
                        guard let pricePairCurrency = pricePairCurrency else {return}
                        self.subPrice = Double(pricePairCurrency.currentPrice!) ?? 0.0
                        completionHandler(true)
                    }else{
                        completionHandler(false)
                    }
                }
            }
        default:
            completionHandler(true)
            break
        }
    }
    func getPriceOfPairCurrency(pairCurrency:PairCurrencyModel){
        //Goi API lay mainprice -> goi API lay sub price -> calculationPipValue
        self.getMainPrice(pairCurrency: self.pairCurrency!) { result in
            print("Get main price success")
        }
        self.getSubPrice(pairCurrency: self.pairCurrency!) { result in
            print("Get sub prtice success")
        }
    }
    func calculationPipValue(pairCurrency:PairCurrencyModel, volume:Double){
        var valuePip:Double = 0.0
        switch pairCurrency.group{
        case "XXX_USD": //Trường hợp 1: Đối với các cặp tiền có USD đứng sau (XXX/USD): 1 pip = 0.0001 USD
            valuePip =  0.0001*volume
            self.valueOfPip = valuePip
            self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
        case "USD_XXX": //Trường hợp 2: Đối với các cặp tiền có USD đứng trước (USD/XXX): 1 pip = (0.0001/tỷ giá) USD
            valuePip = (0.0001/mainPrice)*volume
            self.valueOfPip = valuePip
            self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
        case "XXX_XXX": // Đối với các cặp tiền chéo (không có USD)
            //goi API lay ti gia phu
            switch pairCurrency.name {
            case "USDCAD", "USDCHF", "USDCZK", "USDDKK", "USDHUF", "USDJPY", "USDMXN", "USDNOK", "USDPLN", "USDSEK", "USDSGD", "USDTRY", "USDZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD
                let value = (0.0001/mainPrice)/subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
            default: //1 pip = [(0.0001/tỷ giá chính)*tỷ giá phụ] USD
                let value = (0.0001/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // Nếu XXX là USD thì trường hợp này quay về cách tính của trường hợp 2 (cặp tiền có USD đứng trước), lúc này, 1 pip = ( 0.01/tỷ giá) USD
                valuePip = (0.01/mainPrice)*volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
            }else{ //Nếu XXX không phải là USD thì sẽ quy về cách tính của trường hợp 3 (cặp tiền chéo không có USD) 1 pip = [(0.01/tỷ giá chính)*tỷ giá phụ] USD
                let value = (0.01/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
            }
        case "XAU_USD":
            valuePip =  10.0
            self.valueOfPip = valuePip
            self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
        case "BTC_USD":
            valuePip =  0.1
            self.valueOfPip = valuePip
            self.pipValueLbl.text = (self.valueOfPip.formaterValueOfPips()) + "$"
        default:
            break
        }
    }
    func viewModelCallBack(){
        listPairCurrencyVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        listPairCurrencyVM.afterApiCall = {
            HUD.hide()
        }
        createTransactionVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        createTransactionVM.afterApiCall = {
            HUD.hide()
        }
    }
}
//MARK: UITextFieldDelegate
extension PipValueViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.first == "."{
            textField.text = nil
        }
        switch textField.text?.last {
        case ".":
            print(textField.text?.last)
        default:
            let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
            textField.text = stringNumber
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ","{
            textField.text = textField.text! + "."
            return false
        }
        return true
    }
}
//MARK:
extension PipValueViewController:ListPairCurrencyDelegate{
    func passPairCurrencyData(pairCurrency: PairCurrencyModel) {
        self.pairCurrency = pairCurrency
        self.pairCurrencyNameLbl.text = self.pairCurrency?.name
        self.getPriceOfPairCurrency(pairCurrency: self.pairCurrency!)
    }
}
