//
//  ProfitCalculatorViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 25/09/2021.
//

import UIKit
import PKHUD
class ProfitCalculatorViewController: BaseViewController {

    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var pairCurrencyNameLbl: UILabel!
    @IBOutlet weak var volumeSizeTf: UITextField!
    @IBOutlet weak var entryPriceTf: UITextField!
    @IBOutlet weak var stopLossTf: UITextField!
    @IBOutlet weak var takeProfitTf: UITextField!
    @IBOutlet weak var stopLossLbl: UILabel!
    @IBOutlet weak var takeProfitLbl: UILabel!
    @IBOutlet weak var riskRateRatioLbl: UILabel!
    @IBOutlet weak var amountRiskLbl: UILabel!
    @IBOutlet weak var amountGainLbl: UILabel!
    //
    let createTransactionVM = CreateTransactionViewModel()
    let listPairCurrencyVM = ListPairCurrencyViewModel()
    var pairCurrency:PairCurrencyModel?
    var valueOfPip:Double = 0.0
    var mainPrice:Double = 0.0
//    var amountBalance:Double = 0.0
//    var riskRate:Double = 0.0
//    var entryPrice:Double = 0.0
//    var stopLossPrice:Double = 0.0
    var typeTrading:TypeTransaction = TypeTransaction.Buy
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModelCallBack()
        //
        volumeSizeTf.delegate = self
        entryPriceTf.delegate = self
        stopLossTf.delegate = self
        takeProfitTf.delegate = self
        volumeSizeTf.keyboardType = .decimalPad
        entryPriceTf.keyboardType = .decimalPad
        stopLossTf.keyboardType = .decimalPad
        takeProfitTf.keyboardType = .decimalPad
        //
        self.callAPI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Stop Loss & Take Profit"
    }
    //MARK: UI Event
    @IBAction func listPairCurrencyButtonWasPressed(_ sender: Any) {
        let targetVC = ListPairCurrencyViewController()
        targetVC.currentPairCurrency = self.pairCurrency?.name
        targetVC.delegate = self
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func buyButtonWasPressed(_ sender: Any) {
        typeTrading = .Buy
        buyView.backgroundColor = .systemGreen
        sellView.backgroundColor = .lightGray
    }
    @IBAction func sellButtonWasPressed(_ sender: Any) {
        typeTrading = .Sell
        buyView.backgroundColor = .lightGray
        sellView.backgroundColor = .systemRed
    }
    @IBAction func calculateButtonWasPressed(_ sender: Any) {
        self.view.endEditing(true)
        if !validate(){
            return
        }
        guard let pairCurrency = self.pairCurrency else {return}
        let entryPrice = Double((entryPriceTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let stopLossPrice = Double((stopLossTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let takeProfitPrice = Double((takeProfitTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let lotSize = Double((volumeSizeTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        calculationPipValue(pairCurrency: pairCurrency, volume: 100000) { (pipValue) in
            self.calculateMaxLotAmountGainAndAmountLoss(pipValue: pipValue, entryPrice: entryPrice, stopLossPrice: stopLossPrice, takeProfitPrice: takeProfitPrice, lotSize: lotSize, pairCurrency: pairCurrency)
        }
        
    }
    //MARK: Helper Method
    func callAPI(){
        //Goi API lay danh sach tien te -> goi API lay gia hien tai
        listPairCurrencyVM.getListPairCurrency { (result, listPairCurrency) in
            if result == true{
                guard let list = listPairCurrency else {return}
                self.pairCurrency = list.first
                self.pairCurrencyNameLbl.text = list.first?.name
                //Goi API lay gia hien tai
                self.createTransactionVM.convertCurrency(fromCurrency: (self.pairCurrency?.fromCurrency)!, toCurrency: (self.pairCurrency?.toCurrency)!) { (success, price) in
                    if success{
                        //Cap nhat lai gia
                        print(price)
                        guard let price = price else {return}
                        self.mainPrice = price
                    }
                }
            }
        }
    }
    //
    func calculationPipValue(pairCurrency:PairCurrencyModel, volume:Double, completionHandler:@escaping(_ pipValue:Double) -> Void){
        var valuePip:Double = 0.0
        switch pairCurrency.group{
        case "XXX_USD": //Trường hợp 1: Đối với các cặp tiền có USD đứng sau (XXX/USD): 1 pip = 0.0001 USD
            valuePip =  0.0001*volume
            self.valueOfPip = valuePip
            completionHandler(valuePip)
        case "USD_XXX": //Trường hợp 2: Đối với các cặp tiền có USD đứng trước (USD/XXX): 1 pip = (0.0001/tỷ giá) USD
            valuePip = (0.0001/mainPrice)*volume
            self.valueOfPip = valuePip
            completionHandler(valuePip)
        case "XXX_XXX": // Đối với các cặp tiền chéo (không có USD)
            //goi API lay ti gia phu
            switch pairCurrency.name {
            
            case "USDCAD", "USDCHF", "USDCZK", "USDDKK", "USDHUF", "USDJPY", "USDMXN", "USDNOK", "USDPLN", "USDSEK", "USDSGD", "USDTRY", "USDZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD
                var valueReturn:Double = 0
                createTransactionVM.convertCurrency(fromCurrency: "USD", toCurrency: pairCurrency.fromCurrency!) { [self] (success, price) in
                    if success{
                        guard let subPrice = price else {return}
                        //self.subPrice = price
                        let value = (0.0001/mainPrice)/subPrice
                        valuePip = value * volume
                        self.valueOfPip = valuePip
                        completionHandler(valuePip)
                    }
                }
                
            default: //1 pip = [(0.0001/tỷ giá chính)*tỷ giá phụ] USD
                createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: "USD") { [self] (success, price) in
                    if success{
                        guard let subPrice = price else {return}
                        //self.subPrice = price
                        let value = (0.0001/mainPrice)*subPrice
                        valuePip = value * volume
                        self.valueOfPip = valuePip
                        completionHandler(valuePip)
                    }
                }
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // Nếu XXX là USD thì trường hợp này quay về cách tính của trường hợp 2 (cặp tiền có USD đứng trước), lúc này, 1 pip = ( 0.01/tỷ giá) USD
                valuePip = (0.01/mainPrice)*volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
            }else{ //Nếu XXX không phải là USD thì sẽ quy về cách tính của trường hợp 3 (cặp tiền chéo không có USD) 1 pip = [(0.01/tỷ giá chính)*tỷ giá phụ] USD
                createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: "USD") { [self] (success, price) in
                    if success{
                        guard let subPrice = price else {return}
                        let value = (0.01/mainPrice)*subPrice
                        valuePip = value * volume
                        self.valueOfPip = valuePip
                        completionHandler(valuePip)
                    }
                }
            }
        case "XAU_USD":
            valuePip =  10.0
            self.valueOfPip = valuePip
            completionHandler(valuePip)
        case "BTC_USD":
            valuePip =  0.1
            self.valueOfPip = valuePip
            completionHandler(valuePip)
            
        default:
            break
        }
    }
    //
    func getPriceOfPairCurrency(pairCurrency:PairCurrencyModel){
        createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: pairCurrency.toCurrency!) { (success, price) in
            if success{
                //Cap nhat lai gia
                guard let price = price else {return}
                self.mainPrice = price
            }
        }
    }
    //
    func calculateMaxLotAmountGainAndAmountLoss(pipValue:Double, entryPrice:Double, stopLossPrice:Double, takeProfitPrice:Double, lotSize:Double, pairCurrency:PairCurrencyModel){
        var pipsLoss:Double = 0.0
        var pipsGain:Double = 0.0
        switch pairCurrency.group {
        case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
            pipsLoss = (abs(entryPrice - stopLossPrice)*10000)
            pipsGain = (abs(entryPrice - takeProfitPrice)*10000)
        case CurrencyGroup.XAU_USD.rawValue, CurrencyGroup.BTC_USD.rawValue:
            pipsLoss = (abs(entryPrice - stopLossPrice)*10)
            pipsGain = (abs(entryPrice - takeProfitPrice)*10)
        case CurrencyGroup.XXX_JPY.rawValue:
            pipsLoss = (abs(entryPrice - stopLossPrice)*100)
            pipsGain = (abs(entryPrice - takeProfitPrice)*100)
        default:
            break
        }
        //
//        let maxLossAmount = (balanceAmount * riskRate)/100
//        let maxStandardLots = maxLossAmount/(pipsLoss*pipValue)
        let amountLoss = pipsLoss * pipValue * lotSize
        let amountGain = pipsGain * pipValue * lotSize
        let riskRewardRatio = amountGain/amountLoss
        //Update UI
        self.stopLossLbl.text = String(Int(pipsLoss)) + " Pips"
        self.takeProfitLbl.text = String(Int(pipsGain)) + " Pips"
        self.riskRateRatioLbl.text = "1/" + String(riskRewardRatio.formaterCurrentPriceWithTwoFractionDigits())
        self.amountGainLbl.text = String(amountGain.formaterCurrentPriceWithTwoFractionDigits()) + " $"
        self.amountRiskLbl.text = String(amountLoss.formaterCurrentPriceWithTwoFractionDigits()) + " $"
    }
    //
    func validate() -> Bool{
        let entryPrice = Double((entryPriceTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let stopLossPrice = Double((stopLossTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let takeProfitPrice = Double((takeProfitTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        switch typeTrading {
        case .Buy:
            if stopLossPrice > entryPrice || takeProfitPrice < entryPrice{
                HelperMethod.showAlertWithMessage(message: "Wrong setup buy format")
                return false
            }
        case .Sell:
            if stopLossPrice < entryPrice || takeProfitPrice > entryPrice{
                HelperMethod.showAlertWithMessage(message: "Wrong setup sell format")
                return false
            }
        default:
            break
        }
        return true
    }
    //
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
//MARK: ListPairCurrencyDelegate
extension ProfitCalculatorViewController:ListPairCurrencyDelegate{
    func passPairCurrencyData(pairCurrency: PairCurrencyModel) {
        self.pairCurrency = pairCurrency
        self.pairCurrencyNameLbl.text = self.pairCurrency?.name
        self.getPriceOfPairCurrency(pairCurrency: self.pairCurrency!)
    }
    
    
}
//MARK: UITextFieldDelegate
extension ProfitCalculatorViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == entryPriceTf || textField == stopLossTf || textField == takeProfitTf{
            if textField.text?.first == "."{
                textField.text = nil
            }
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                switch self.pairCurrency?.group {
                case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 5)
                    textField.text = stringNumber
                case CurrencyGroup.XXX_JPY.rawValue, CurrencyGroup.XAU_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 3)
                    textField.text = stringNumber
                case CurrencyGroup.BTC_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
                    textField.text = stringNumber
                default:
                    break
                }
            }
        }
        //
        if textField == volumeSizeTf{
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
    }
}
