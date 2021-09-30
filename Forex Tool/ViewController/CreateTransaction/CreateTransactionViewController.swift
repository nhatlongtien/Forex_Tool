//
//  CreateTransactionViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit
import PKHUD
import Firebase
import FirebaseFirestore
class CreateTransactionViewController: UIViewController {
    
    @IBOutlet weak var namePairCurrency: UILabel!
    @IBOutlet weak var currentPriceLbl: UILabel!
    @IBOutlet weak var valuePipsLbl: UILabel!
    @IBOutlet weak var riskRateLbl: UILabel!
    @IBOutlet weak var typeTransactionLbl: UILabel!
    @IBOutlet weak var capitalTf: UITextField!
    @IBOutlet weak var entryPointTf: UITextField!
    @IBOutlet weak var stopLoseTf: UITextField!
    @IBOutlet weak var takeProfitTf: UITextField!
    @IBOutlet weak var lotSizeTf: UITextField!
    @IBOutlet weak var maxAlowedLotLbl: UILabel!
    
    @IBOutlet weak var pipsLoseLbl: UILabel!
    @IBOutlet weak var pipsProfitLbl: UILabel!
    @IBOutlet weak var loseLbl: UILabel!
    @IBOutlet weak var rewardLbl: UILabel!
    @IBOutlet weak var rrLbl: UILabel!
    //
    var riskRatePickerView = UIPickerView()
    var typeTransactionPickerView = UIPickerView()
    //
    let createTransactionVM = CreateTransactionViewModel()
    let listPairCurrencyVM = ListPairCurrencyViewModel()
    var pairCurrency:PairCurrencyModel?
    var mainPrice:Double?
    var subPrice:Double?
    var valueOfPip:Double?
    var totalCapital:Double? = 0
    var riskRate:Double? = 2.0 //Default value
    var entryPoint:Double?
    var stopLosePoint:Double?
    var takeProfitPoint:Double?
    var pipsLossValue:Double?
    var pipsProfitValue:Double?
    var maxAlowLotValue:Double?
    var lossMoneyValue:Double?
    var rewardMoneyValue:Double?
    var lotSize:Double?
    //
    var selectedTransaction:TransactionModel?
    var isEdit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModelCallBack()
        //
        callAPI()
        //
        entryPointTf.delegate = self
        stopLoseTf.delegate = self
        takeProfitTf.delegate = self
        capitalTf.delegate = self
        lotSizeTf.delegate = self
        capitalTf.keyboardType = .decimalPad
        entryPointTf.keyboardType = .decimalPad
        stopLoseTf.keyboardType = .decimalPad
        takeProfitTf.keyboardType = .decimalPad
        lotSizeTf.keyboardType = .decimalPad
        //
//        self.pipsLoseLbl.text = "PIPS LOSS: ####"
//        self.pipsProfitLbl.text = "PIPS PROFIT: ####"
//        self.maxAlowedLotLbl.text = "*Maximum Alowed Lot: ####"
//        self.rrLbl.text = "R:R = ####"
//        self.loseLbl.text = "Loss: ####"
//        self.rewardLbl.text = "Reward: ####"
//        self.pipsLossValue = nil
//        self.pipsProfitValue = nil
//        self.maxAlowLotValue = nil
//        self.riskRate = nil
//        self.lostMoneyValue = nil
//        self.rewardMoneyValue = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Create Transaction"
        //
        self.pipsLoseLbl.text = "PIPS LOSS: ####"
        self.pipsProfitLbl.text = "PIPS PROFIT: ####"
        self.maxAlowedLotLbl.text = "*Maximum Alowed Lot: ####"
        self.rrLbl.text = "R:R = ####"
        self.loseLbl.text = "Loss: ####"
        self.rewardLbl.text = "Reward: ####"
        //
        self.capitalTf.text = ""
        self.entryPointTf.text = ""
        self.stopLoseTf.text = ""
        self.takeProfitTf.text = ""
        self.lotSizeTf.text = ""
        //
        self.pipsLossValue = nil
        self.pipsProfitValue = nil
        self.maxAlowLotValue = nil
        self.riskRate = 2.0
        self.lossMoneyValue = nil
        self.rewardMoneyValue = nil
        self.lotSize = nil
    }
    //MARK: Ui Event
    @IBAction func choosePairCurrencyButtonWasPressed(_ sender: Any) {
        let targetVC = ListPairCurrencyViewController()
        targetVC.currentPairCurrency = namePairCurrency.text
        targetVC.delegate = self
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func chooseRiskRateButtonWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Select Your Risk Rate", message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        riskRatePickerView = UIPickerView(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 35, height: 162))
        riskRatePickerView.dataSource = self
        riskRatePickerView.delegate = self
        riskRatePickerView.selectRow(3, inComponent: 0, animated: true)
        alert.view.addSubview(riskRatePickerView)
        let btnCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(btnCancel)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func chooseTypeTransactionWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Select Your Type Transaction", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        typeTransactionPickerView = UIPickerView(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 35, height: 120))
        typeTransactionPickerView.dataSource = self
        typeTransactionPickerView.delegate = self
        typeTransactionPickerView.selectRow(1, inComponent: 0, animated: true)
        alert.view.addSubview(typeTransactionPickerView)
        let btnOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createButtonWasPressed(_ sender: Any) {
        var status:String?
        switch self.typeTransactionLbl.text {
        case "Buy", "Sell":
            status = StatusTransaction.Active.rawValue
        case "Buy Limit", "Sell Limit":
            status = StatusTransaction.Pending.rawValue
        default:
            break
        }
        HUD.show(.systemActivity)
        var ref:DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("Transactions").addDocument(data: [
            "dateCreate":HelperMethod.convertDateToString(date: Date(), dateFormater: "yyyy-MM-dd HH:mm:ss"),
            "pairCurrency":self.pairCurrency?.name,
            "groupCurrency":self.pairCurrency?.group,
            "riskRate":self.riskRate,
            "detail": [
                "entryPoint":self.entryPoint,
                "stopLossPoint":self.stopLosePoint,
                "takeProfitPoint":self.takeProfitPoint,
                "lotSize":self.lotSize,
                "pipsLoss":self.pipsLossValue,
                "pipsProfit":self.pipsProfitValue,
                "rewardMoney": self.rewardMoneyValue,
                "lossMoney":self.lossMoneyValue,
                "RRRate":self.rrLbl.text,
                "type": self.typeTransactionLbl.text,
                "result": ResultTransaction.Unknow.rawValue
            ],
            "userID":Constant.defaults.string(forKey: Constant.USER_ID),
            "status":status,
            "transactionID": UUID().uuidString,
            "timeStamp": Timestamp(date: Date())
            
        ], completion: { (error) in
            if let err = error{
                HelperMethod.showAlertWithMessage(message: "Error adding document: \(err)")
            }else{
                print("Document added with ID: \(ref!.documentID)")
            }
            HUD.hide()
        })
        
    }
    //MARK: Helper Method
    private func viewModelCallBack() {
        listPairCurrencyVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        listPairCurrencyVM.afterApiCall = {
            HUD.hide()
        }
        //
        createTransactionVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        createTransactionVM.afterApiCall = {
            HUD.hide()
        }
    }
    func callAPI(){
        //Goi API lay danh sach tien te -> goi API lay gia hien tai
        listPairCurrencyVM.getListPairCurrency { (result, listPairCurrency) in
            if result == true{
                guard let list = listPairCurrency else {return}
                self.pairCurrency = list.first
                self.namePairCurrency.text = self.pairCurrency?.name
                //Goi API lay gia hien tai
                self.createTransactionVM.convertCurrency(fromCurrency: (self.pairCurrency?.fromCurrency)!, toCurrency: (self.pairCurrency?.toCurrency)!) { (success, price) in
                    if success{
                        //Cap nhat lai gia
                        print(price)
                        guard let price = price else {return}
                        self.mainPrice = price
                        self.updateDataForCurrentPrice(pairCurrency: self.pairCurrency!, price: price)
                        //
                        self.calculationValuePerPipsOfStandardLot(pairCurrency: self.pairCurrency!)
                    }
                }
            }
        }
    }
    func convertCurrency(){
        createTransactionVM.convertCurrency(fromCurrency: (self.pairCurrency?.fromCurrency)!, toCurrency: (self.pairCurrency?.toCurrency)!) { (success, price) in
            if success{
                //Cap nhat lai gia
                print(price)
                guard let price = price else {return}
                self.mainPrice = price
                self.updateDataForCurrentPrice(pairCurrency: self.pairCurrency!, price: price)
                //
                self.calculationValuePerPipsOfStandardLot(pairCurrency: self.pairCurrency!)
            }
        }
    }
    func calculationValuePerPipsOfStandardLot(pairCurrency:PairCurrencyModel){
        var valuePip:Double = 0.0
        switch pairCurrency.group{
        case "XXX_USD": //Trường hợp 1: Đối với các cặp tiền có USD đứng sau (XXX/USD): 1 pip = 0.0001 USD
            valuePip =  0.0001*100000
            self.valueOfPip = valuePip
            self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
        case "USD_XXX": //Trường hợp 2: Đối với các cặp tiền có USD đứng trước (USD/XXX): 1 pip = (0.0001/tỷ giá) USD
            valuePip = (0.0001/mainPrice!)*100000
            self.valueOfPip = valuePip
            self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
        case "XXX_XXX": // Đối với các cặp tiền chéo (không có USD)
            //goi API lay ti gia phu
            switch pairCurrency.name {
            
            case "USDCAD", "USDCHF", "USDCZK", "USDDKK", "USDHUF", "USDJPY", "USDMXN", "USDNOK", "USDPLN", "USDSEK", "USDSGD", "USDTRY", "USDZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD
                var valueReturn:Double = 0
                createTransactionVM.convertCurrency(fromCurrency: "USD", toCurrency: pairCurrency.fromCurrency!) { [self] (success, price) in
                    if success{
                        guard let price = price else {return}
                        self.subPrice = price
                        let value = (0.0001/mainPrice!)/subPrice!
                        valuePip = value * 100000
                        self.valueOfPip = valuePip
                        self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
                    }
                }
                
            default: //1 pip = [(0.0001/tỷ giá chính)*tỷ giá phụ] USD
                createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: "USD") { [self] (success, price) in
                    if success{
                        guard let price = price else {return}
                        self.subPrice = price
                        let value = (0.0001/mainPrice!)*subPrice!
                        valuePip = value * 100000
                        self.valueOfPip = valuePip
                        self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
                    }
                }
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // Nếu XXX là USD thì trường hợp này quay về cách tính của trường hợp 2 (cặp tiền có USD đứng trước), lúc này, 1 pip = ( 0.01/tỷ giá) USD
                valuePip = (0.01/mainPrice!)*100000
                self.valueOfPip = valuePip
                self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
            }else{ //Nếu XXX không phải là USD thì sẽ quy về cách tính của trường hợp 3 (cặp tiền chéo không có USD) 1 pip = [(0.01/tỷ giá chính)*tỷ giá phụ] USD
                createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: "USD") { [self] (success, price) in
                    if success{
                        guard let price = price else {return}
                        self.subPrice = price
                        let value = (0.01/mainPrice!)*subPrice!
                        valuePip = value * 100000
                        self.valueOfPip = valuePip
                        self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
                    }
                }
            }
        case "XAU_USD":
            valuePip =  10.0
            self.valueOfPip = valuePip
            self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
        case "BTC_USD":
            valuePip =  0.1
            self.valueOfPip = valuePip
            self.valuePipsLbl.text = (self.valueOfPip?.formaterValueOfPips())! + "$"
            
        default:
            break
        }
        ////////
        
    }
    func updateDataForCurrentPrice(pairCurrency:PairCurrencyModel, price:Double){
        switch pairCurrency.group {
        case CurrencyGroup.XXX_JPY.rawValue, CurrencyGroup.XAU_USD.rawValue:
            let valuePrice = price.formaterCurrentPriceWith3FractionDigits()
            self.currentPriceLbl.text = "Current Price: \(valuePrice)"
        case CurrencyGroup.BTC_USD.rawValue:
            let valuePrice = price.formaterCurrentPriceWithTwoFractionDigits()
            self.currentPriceLbl.text = "Current Price: \(valuePrice)"
        default:
            let valuePrice = price.formaterCurrentPriceWithFiveFractionDigits()
            self.currentPriceLbl.text = "Current Price: \(valuePrice)"
        }
    }
    //
    func calculationDifferPointAndMaxLot(entryPoint:String?, SLPoint:String?, riskRate:Double, pairCurrency:PairCurrencyModel, TPPoint:String?){
        if entryPoint == nil || SLPoint == nil || entryPoint == "" || SLPoint == "" {
            self.pipsLoseLbl.text = "PIPS LOSS: ####"
            
            self.maxAlowedLotLbl.text = "*Maximum Alowed Lot: ####"
            self.maxAlowLotValue = nil
            self.pipsLossValue = nil
        }else if entryPoint != nil || SLPoint != nil || entryPoint != "" || SLPoint != "" {
            guard let entryValue = Double(entryPoint!.replacingOccurrences(of: ",", with: "")) else {return}
            guard let SLValue = Double(SLPoint!.replacingOccurrences(of: ",", with: "")) else {return}
            self.entryPoint = entryValue
            self.stopLosePoint = SLValue
            switch pairCurrency.group {
            case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
                self.pipsLossValue = (abs(entryValue - SLValue)*10000)
            case CurrencyGroup.XAU_USD.rawValue, CurrencyGroup.BTC_USD.rawValue:
                self.pipsLossValue = (abs(entryValue - SLValue)*10)
            case CurrencyGroup.XXX_JPY.rawValue:
                self.pipsLossValue = (abs(entryValue - SLValue)*100)
            default:
                break
            }
            self.pipsLoseLbl.text = "PIPS LOSS: " + String(pipsLossValue!.formaterCurrentPriceWithTwoFractionDigits())
            
            //
            guard let totalValue = self.totalCapital else {return}
            let maxMoneyLose = (totalValue * riskRate)/100
            let maxLot = maxMoneyLose/(self.pipsLossValue!*self.valueOfPip!)
            self.maxAlowedLotLbl.text = "*Maximum Alowed Lot: " + String(maxLot.formaterCurrentPriceWithTwoFractionDigits())
            
        }
        if entryPoint == nil || entryPoint == "" || TPPoint == nil || TPPoint == ""{
            self.pipsProfitLbl.text = "PIPS PROFIT: ####"
            self.pipsProfitValue = nil
        }else if TPPoint != "" && entryPoint != ""{
            //
            guard let TPValue = Double(TPPoint!.replacingOccurrences(of: ",", with: "")) else {return}
            self.takeProfitPoint = TPValue
            switch pairCurrency.group {
            case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
                self.pipsProfitValue = (abs(self.entryPoint! - self.takeProfitPoint!)*10000)
            case CurrencyGroup.XAU_USD.rawValue, CurrencyGroup.BTC_USD.rawValue:
                self.pipsProfitValue = (abs(self.entryPoint! - self.takeProfitPoint!)*10)
            case CurrencyGroup.XXX_JPY.rawValue:
                self.pipsProfitValue = (abs(self.entryPoint! - self.takeProfitPoint!)*100)
            default:
                break
            }
            self.pipsProfitLbl.text = "PIPS PROFIT: " + String(pipsProfitValue!.formaterCurrentPriceWithTwoFractionDigits())
        }
    }
    func calculationLoseAndRewardMoney(lotSize:String?){
        if lotSize == nil || lotSize == ""{
            self.loseLbl.text = "Loss: ####"
            self.rewardLbl.text = "Reward: ####"
            self.lossMoneyValue = nil
            self.rewardMoneyValue = nil
        }else{
            guard let lotSizeValue = Double(lotSize!.replacingOccurrences(of: ",", with: "")) else {return}
            self.lotSize = lotSizeValue
            //Tinh so tien mat
            self.lossMoneyValue = ((self.pipsLossValue! * self.valueOfPip!))*self.lotSize!
            self.loseLbl.text = "Loss: " + String((self.lossMoneyValue?.formaterCurrentPriceWithTwoFractionDigits())!) + "$"
            //Tinh so tien loi nhuan
            self.rewardMoneyValue = ((self.pipsProfitValue! * self.valueOfPip!))*self.lotSize!
            self.rewardLbl.text = "Reward " + String((self.rewardMoneyValue?.formaterCurrentPriceWithTwoFractionDigits())!) + "$"
            //Tinh ti le R:R
            let rewardRate = (self.rewardMoneyValue! / self.lossMoneyValue!)
            self.rrLbl.text = "R:R = 1:" + String(rewardRate.formaterCurrentPriceWithTwoFractionDigits())
        }
    }
}
//MARK: ListPairCurrencyDelegate
extension CreateTransactionViewController: ListPairCurrencyDelegate{
    func passPairCurrencyData(pairCurrency: PairCurrencyModel) {
        self.pairCurrency = pairCurrency
        self.namePairCurrency.text = pairCurrency.name
        //
        self.convertCurrency()
    }
}
//MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension CreateTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == riskRatePickerView{
            return 1
        }else if pickerView == typeTransactionPickerView{
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == riskRatePickerView{
            return Constant.listRiskRateValue.count
        }else if pickerView == typeTransactionPickerView{
            return Constant.listTypeTransaction.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == riskRatePickerView{
            let displaceValue = String(Constant.listRiskRateValue[row]) + " %"
            return displaceValue
        }else{
            return Constant.listTypeTransaction[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == riskRatePickerView{
            self.riskRate = Constant.listRiskRateValue[row]
            self.riskRateLbl.text = String(Constant.listRiskRateValue[row]) + " %"
            //tinh toan so lot toi da va gia tri chenh lech
            self.calculationDifferPointAndMaxLot(entryPoint: self.entryPointTf.text, SLPoint: self.stopLoseTf.text, riskRate: self.riskRate!, pairCurrency: self.pairCurrency!, TPPoint: self.takeProfitTf.text)
        }else{
            self.typeTransactionLbl.text = Constant.listTypeTransaction[row]
        }
    }
    
    
}
//
extension CreateTransactionViewController:UITextFieldDelegate{
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == entryPointTf{
//            print(textField.text)
//        }
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == entryPointTf{
            if capitalTf.text == nil || capitalTf.text == ""{
                HelperMethod.showAlertWithMessage(message: "Please enter your entry your capital!")
            }
        }
        if textField == stopLoseTf{
            if entryPointTf.text == nil || entryPointTf.text == "" {
                HelperMethod.showAlertWithMessage(message: "Please enter your entry point!")
            }
        }
        if textField == lotSizeTf{
            if takeProfitTf.text == "" || takeProfitTf.text == nil{
                HelperMethod.showAlertWithMessage(message: "Please enter your take profit point!")
            }
        }
        if textField == capitalTf{
            capitalTf.text = nil
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == entryPointTf{
            if textField.text?.first == "."{
                self.entryPointTf.text = nil
            }
            //real-time formate input
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                switch self.pairCurrency?.group {
                case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 5)
                    self.entryPointTf.text = stringNumber
                case CurrencyGroup.XXX_JPY.rawValue, CurrencyGroup.XAU_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 3)
                    self.entryPointTf.text = stringNumber
                case CurrencyGroup.BTC_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
                    self.entryPointTf.text = stringNumber
                default:
                    break
                }
            }
            //tinh toan so lot toi da va gia tri chenh lech
            self.calculationDifferPointAndMaxLot(entryPoint: self.entryPointTf.text, SLPoint: self.stopLoseTf.text, riskRate: self.riskRate!, pairCurrency: self.pairCurrency!, TPPoint: self.takeProfitTf.text)
        }
        if textField == stopLoseTf{
            if textField.text?.first == "."{
                self.stopLoseTf.text = nil
            }
            //real-time formate input
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                switch self.pairCurrency?.group {
                case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 5)
                    self.stopLoseTf.text = stringNumber
                case CurrencyGroup.XXX_JPY.rawValue, CurrencyGroup.XAU_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 3)
                    self.stopLoseTf.text = stringNumber
                case CurrencyGroup.BTC_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
                    self.stopLoseTf.text = stringNumber
                default:
                    break
                }
            }
            //tinh toan so lot toi da va gia tri chenh lech
            self.calculationDifferPointAndMaxLot(entryPoint: self.entryPointTf.text, SLPoint: self.stopLoseTf.text, riskRate: self.riskRate!, pairCurrency: self.pairCurrency!, TPPoint: self.takeProfitTf.text)
        }
        if textField == takeProfitTf{
            if textField.text?.first == "."{
                self.takeProfitTf.text = nil
            }
            //real-time formate input
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                switch self.pairCurrency?.group {
                case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 5)
                    self.takeProfitTf.text = stringNumber
                case CurrencyGroup.XXX_JPY.rawValue, CurrencyGroup.XAU_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 3)
                    self.takeProfitTf.text = stringNumber
                case CurrencyGroup.BTC_USD.rawValue:
                    let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
                    self.takeProfitTf.text = stringNumber
                default:
                    break
                }
            }
            //tinh toan so lot toi da va gia tri chenh lech
            self.calculationDifferPointAndMaxLot(entryPoint: self.entryPointTf.text, SLPoint: self.stopLoseTf.text, riskRate: self.riskRate!, pairCurrency: self.pairCurrency!, TPPoint: self.takeProfitTf.text)
        }
        //
        if textField == capitalTf{
            if textField.text?.first == "."{
                self.capitalTf.text = nil
            }
            //real-time formate input
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
                self.capitalTf.text = stringNumber
                
            }
            self.totalCapital = Double(capitalTf.text!.replacingOccurrences(of: ",", with: ""))
            //tinh toan so lot toi da va gia tri chenh lech
            self.calculationDifferPointAndMaxLot(entryPoint: self.entryPointTf.text, SLPoint: self.stopLoseTf.text, riskRate: self.riskRate!, pairCurrency: self.pairCurrency!, TPPoint: self.takeProfitTf.text)
            print(totalCapital)
        }
        //
        if textField == lotSizeTf{
            if textField.text?.first == "."{
                self.lotSizeTf.text = nil
            }
            //real-time formate input
            switch textField.text?.last {
            case ".":
                print(textField.text?.last)
            default:
                let stringNumber = HelperMethod.filterString(input: (textField.text!.replacingOccurrences(of: ",", with: "")), numberDigitAfterDecimal: 2)
                self.lotSizeTf.text = stringNumber
                
            }
            self.lotSize = Double((lotSizeTf.text?.replacingOccurrences(of: ",", with: ""))!)
            //
            self.calculationLoseAndRewardMoney(lotSize: self.lotSizeTf.text)
        }
    }
    ///
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == capitalTf{
            if textField.text == nil || textField.text == ""{
                capitalTf.text = nil
            }else{
                capitalTf.text = textField.text! + " $"
            }
        }
    }
    
}

