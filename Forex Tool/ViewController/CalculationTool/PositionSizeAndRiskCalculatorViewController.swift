//
//  PositionSizeCalculatorViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 27/09/2021.
//

import UIKit
import PKHUD
class PositionSizeAndRiskCalculatorViewController: BaseViewController {
    @IBOutlet weak var pairCurrencyTitle: UILabel!
    @IBOutlet weak var accountBalanceTitle: UILabel!
    @IBOutlet weak var riskRateTitle: UILabel!
    @IBOutlet weak var entryPriceTitle: UILabel!
    @IBOutlet weak var stopLossPriceTitle: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var amountLossTitle: UILabel!
    @IBOutlet weak var pipValueTitle: UILabel!
    
    @IBOutlet weak var pairCurrencyNameLbl: UILabel!
    @IBOutlet weak var amountBalanceTf: UITextField!
    @IBOutlet weak var riskRateTf: UITextField!
    @IBOutlet weak var entryPriceTf: UITextField!
    @IBOutlet weak var stopLossPriceTf: UITextField!
    @IBOutlet weak var amountToLossLbl: UILabel!
    @IBOutlet weak var standardLotsLbl: UILabel!
    @IBOutlet weak var miniLotsLbl: UILabel!
    @IBOutlet weak var microLotsLbl: UILabel!
    @IBOutlet weak var pipValueLbl: UILabel!
    //
    let createTransactionVM = CreateTransactionViewModel()
    let listPairCurrencyVM = ListPairCurrencyViewModel()
    var pairCurrency:PairCurrencyModel?
    var valueOfPip:Double = 0.0
    var mainPrice:Double = 0.0
    var subPrice:Double = 0.0
    var amountBalance:Double = 0.0
    var riskRate:Double = 0.0
    var entryPrice:Double = 0.0
    var stopLossPrice:Double = 0.0
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModelCallBack()
        //
        amountBalanceTf.delegate = self
        riskRateTf.delegate = self
        entryPriceTf.delegate = self
        stopLossPriceTf.delegate = self
        amountBalanceTf.keyboardType = .decimalPad
        riskRateTf.keyboardType = .decimalPad
        entryPriceTf.keyboardType = .decimalPad
        stopLossPriceTf.keyboardType = .decimalPad
        // Do any additional setup after loading the view.
        self.callAPI()
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Position Size & Risk".localized()
    }
    //MARK: UI Event
    @IBAction func listPairCurrencyButtonWasPressed(_ sender: Any) {
        let targetVC = ListPairCurrencyViewController()
        targetVC.currentPairCurrency = self.pairCurrency?.name
        targetVC.delegate = self
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func calculateButtonWasPressed(_ sender: Any) {
        guard let pairCurrency = self.pairCurrency else {return}
        let balanceAmount = Double((amountBalanceTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let riskRate = Double((riskRateTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let entryPrice = Double((entryPriceTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        let stopLossPrice = Double((stopLossPriceTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
        calculationPipValue(pairCurrency: pairCurrency, volume: 100000) { (pipValue) in
            self.calculateMaxLotAndAmountLoss(pipValue: pipValue, balanceAmount: balanceAmount, riskRate: riskRate, entryPrice: entryPrice, stopLossPrice: stopLossPrice, pairCurrency: pairCurrency)
        }
    }
    //MARK: Helper Method
    func setupUI(){
        pairCurrencyTitle.text = "Pair Currency".localized()
        accountBalanceTitle.text = "Balance Account".localized()
        amountBalanceTf.placeholder = "Enter your balance account".localized()
        riskRateTitle.text = "Risk Rate".localized()
        riskRateTf.placeholder = "Enter your risk rate".localized()
        entryPriceTitle.text = "Entry Price".localized()
        entryPriceTf.placeholder = "Enter your entry point".localized()
        stopLossPriceTf.placeholder = "Enter your stop loss point".localized()
        stopLossPriceTitle.text = "Stop Loss Price".localized()
        calculateButton.setTitle("Calculate".localized(), for: .normal)
        resultTitle.text = "Result".localized()
        amountLossTitle.text = "Amount Loss".localized()
        pipValueTitle.text = "Value Pips/Standard Lot".localized()
    }
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
                        print("get sub price success")
                    }
                }
            }
        }
    }
    //
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
            case "USD/CAD", "USD/CHF", "USD/CZK", "USD/DKK", "USD/HUF", "USD/JPY", "USD/MXN", "USD/NOK", "USD/PLN", "USD/SEK", "USD/SGD", "USD/TRY", "USD/ZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD:
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
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == false{
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
                let value = (0.0001/mainPrice)/subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
                var valueReturn:Double = 0
            default: //1 pip = [(0.0001/tỷ giá chính)*tỷ giá phụ] USD
                let value = (0.0001/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // Nếu XXX là USD thì trường hợp này quay về cách tính của trường hợp 2 (cặp tiền có USD đứng trước), lúc này, 1 pip = ( 0.01/tỷ giá) USD
                valuePip = (0.01/mainPrice)*volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
            }else{ //Nếu XXX không phải là USD thì sẽ quy về cách tính của trường hợp 3 (cặp tiền chéo không có USD) 1 pip = [(0.01/tỷ giá chính)*tỷ giá phụ] USD
                let value = (0.01/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
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
        self.getMainPrice(pairCurrency: self.pairCurrency!) { success in
            if success{
                print("Get main price success")
            }
        }
        self.getSubPrice(pairCurrency: self.pairCurrency!) { success in
            if success{
                print("get sub price success")
            }
        }
    }
    //
    func calculateMaxLotAndAmountLoss(pipValue:Double, balanceAmount:Double, riskRate:Double, entryPrice:Double, stopLossPrice:Double, pairCurrency:PairCurrencyModel){
        var pipsLoss:Double = 0.0
        switch pairCurrency.group {
        case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
            pipsLoss = (abs(entryPrice - stopLossPrice)*10000)
        case CurrencyGroup.XAU_USD.rawValue, CurrencyGroup.BTC_USD.rawValue:
            pipsLoss = (abs(entryPrice - stopLossPrice)*10)
        case CurrencyGroup.XXX_JPY.rawValue:
            pipsLoss = (abs(entryPrice - stopLossPrice)*100)
        default:
            break
        }
        //
        let maxLossAmount = (balanceAmount * riskRate)/100
        let maxStandardLots = maxLossAmount/(pipsLoss*pipValue)
        let maxMiniLots = maxStandardLots * 10
        let maxMicroLots = maxStandardLots * 100
        //Update UI
        self.standardLotsLbl.text = String(maxStandardLots.formaterCurrentPriceWithTwoFractionDigits()) + " Lots"
        self.miniLotsLbl.text = String(maxMiniLots.formaterCurrentPriceWithTwoFractionDigits()) + " Lots"
        self.microLotsLbl.text = String(maxMicroLots.formaterCurrentPriceWithTwoFractionDigits()) + " Lots"
        self.amountToLossLbl.text = String(maxLossAmount.formaterCurrentPriceWithTwoFractionDigits()) + " $"
        self.pipValueLbl.text = String(pipValue.formaterValueOfPips()) + " $"
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
extension PositionSizeAndRiskCalculatorViewController:ListPairCurrencyDelegate{
    func passPairCurrencyData(pairCurrency: PairCurrencyModel) {
        self.pairCurrency = pairCurrency
        self.pairCurrencyNameLbl.text = self.pairCurrency?.name
        self.getPriceOfPairCurrency(pairCurrency: self.pairCurrency!)
    }
}
//MARK: UITextFieldDelegate
extension PositionSizeAndRiskCalculatorViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == entryPriceTf || textField == stopLossPriceTf{
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
        if textField == amountBalanceTf{
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
        //
        if textField == riskRateTf{
            if textField.text?.first == "."{
                textField.text = nil
            }
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 1)
                textField.text = stringNumber
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == riskRateTf{
            if string == ","{
                textField.text = textField.text! + "."
                return false
            }
            let nsString = NSString(string: textField.text!)
            let newText = nsString.replacingCharacters(in: range, with: string)
            let valueInput = Double(newText.replacingOccurrences(of: ",", with: "")) ?? 0.0
            
            return valueInput >= 0 && valueInput <= 100
        }
        //
        if string == ","{
            textField.text = textField.text! + "."
            return false
        }
        return true
    }
}
