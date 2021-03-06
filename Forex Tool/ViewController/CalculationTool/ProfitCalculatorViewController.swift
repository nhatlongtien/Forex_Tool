//
//  ProfitCalculatorViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 25/09/2021.
//

import UIKit
import PKHUD
class ProfitCalculatorViewController: BaseViewController {
    @IBOutlet weak var pairCurrencyTitle: UILabel!
    @IBOutlet weak var directionTitle: UILabel!
    @IBOutlet weak var buyTitle: UILabel!
    @IBOutlet weak var sellTitle: UILabel!
    @IBOutlet weak var tradingVolume: UILabel!
    @IBOutlet weak var entryPrice: UILabel!
    @IBOutlet weak var stopLossPriceTitle: UILabel!
    @IBOutlet weak var takeProfitPriceTitle: UILabel!
    @IBOutlet weak var caculateButton: UIButton!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var stopLossAtTitle: UILabel!
    @IBOutlet weak var takeProfitAtTitle: UILabel!
    @IBOutlet weak var riskRateRatioTitle: UILabel!
    @IBOutlet weak var amountToRiskTitle: UILabel!
    @IBOutlet weak var amountToGainTitle: UILabel!
    
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
    var subPrice:Double = 0.0
    var typeTrading:TypeTransaction = TypeTransaction.Buy
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupUI()
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
        self.title = "Stop Loss & Rake Profit".localized()
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
    func setupUI(){
        pairCurrencyTitle.text = "Pair Currency".localized()
        directionTitle.text = "Direction".localized()
        tradingVolume.text = "Trading volume (standard lot)".localized()
        volumeSizeTf.placeholder = "Enter your position size (volume)".localized()
        entryPrice.text = "Entry Price".localized()
        buyTitle.text = "Buy".localized()
        sellTitle.text = "Sell".localized()
        entryPriceTf.placeholder = "Enter your entry point".localized()
        stopLossPriceTitle.text = "Stop Loss Price".localized()
        stopLossTf.placeholder = "Enter your stop loss point".localized()
        takeProfitPriceTitle.text = "Take Profit Price".localized()
        takeProfitTf.placeholder = "Enter your take profit point".localized()
        caculateButton.setTitle("Calculate".localized(), for: .normal)
        resultTitle.text = "Result".localized()
        stopLossAtTitle.text = "Stop Loss at".localized()
        takeProfitAtTitle.text = "Take Profit at".localized()
        amountToRiskTitle.text = "Amount Loss".localized()
        amountToGainTitle.text = "Amount Gain".localized()
        riskRateRatioTitle.text = "Risk Reward Ratio".localized()
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
            case "USDCAD", "USDCHF", "USDCZK", "USDDKK", "USDHUF", "USDJPY", "USDMXN", "USDNOK", "USDPLN", "USDSEK", "USDSGD", "USDTRY", "USDZAR": //Nh??ng n???u c???p t??? gi?? ph??? c?? USD ?????ng tr?????c th??: 1 pip = [(0.0001/t??? gi?? ch??nh)/t??? gi?? ph???] USD:
                createTransactionVM.getLatestPriceOfPairCurrency(fromCurrency: "USD", toCurrency: pairCurrency.fromCurrency!) { success, pricePairCurrency in
                    if success{
                        guard let pricePairCurrency = pricePairCurrency else {return}
                        self.subPrice = Double(pricePairCurrency.currentPrice!) ?? 0.0
                        completionHandler(true)
                    }else{
                        completionHandler(false)
                    }
                }
            default: //1 pip = [(0.0001/t??? gi?? ch??nh)*t??? gi?? ph???] USD
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
    func calculationPipValue(pairCurrency:PairCurrencyModel, volume:Double, completionHandler:@escaping(_ pipValue:Double) -> Void){
        var valuePip:Double = 0.0
        switch pairCurrency.group{
        case "XXX_USD": //Tr?????ng h???p 1: ?????i v???i c??c c???p ti???n c?? USD ?????ng sau (XXX/USD): 1 pip = 0.0001 USD
            valuePip =  0.0001*volume
            self.valueOfPip = valuePip
            completionHandler(valuePip)
        case "USD_XXX": //Tr?????ng h???p 2: ?????i v???i c??c c???p ti???n c?? USD ?????ng tr?????c (USD/XXX): 1 pip = (0.0001/t??? gi??) USD
            valuePip = (0.0001/mainPrice)*volume
            self.valueOfPip = valuePip
            completionHandler(valuePip)
        case "XXX_XXX": // ?????i v???i c??c c???p ti???n ch??o (kh??ng c?? USD)
            //goi API lay ti gia phu
            switch pairCurrency.name {
            
            case "USD/CAD", "USD/CHF", "USD/CZK", "USD/DKK", "USD/HUF", "USD/JPY", "USD/MXN", "USD/NOK", "USD/PLN", "USD/SEK", "USD/SGD", "USD/TRY", "USD/ZAR": //Nh??ng n???u c???p t??? gi?? ph??? c?? USD ?????ng tr?????c th??: 1 pip = [(0.0001/t??? gi?? ch??nh)/t??? gi?? ph???] USD
                let value = (0.0001/mainPrice)/subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
            default: //1 pip = [(0.0001/t??? gi?? ch??nh)*t??? gi?? ph???] USD
                let value = (0.0001/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // N???u XXX l?? USD th?? tr?????ng h???p n??y quay v??? c??ch t??nh c???a tr?????ng h???p 2 (c???p ti???n c?? USD ?????ng tr?????c), l??c n??y, 1 pip = ( 0.01/t??? gi??) USD
                valuePip = (0.01/mainPrice)*volume
                self.valueOfPip = valuePip
                completionHandler(valuePip)
            }else{ //N???u XXX kh??ng ph???i l?? USD th?? s??? quy v??? c??ch t??nh c???a tr?????ng h???p 3 (c???p ti???n ch??o kh??ng c?? USD) 1 pip = [(0.01/t??? gi?? ch??nh)*t??? gi?? ph???] USD
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ","{
            textField.text = textField.text! + "."
            return false
        }
        return true
        
    }
}
