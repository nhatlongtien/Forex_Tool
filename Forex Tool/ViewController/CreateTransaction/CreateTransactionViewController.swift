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
import Localize_Swift
class CreateTransactionViewController: BaseViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var chartImageView: UIImageView!
    @IBOutlet weak var reasionView: UIView!
    @IBOutlet weak var heightReasonView: NSLayoutConstraint!
    
    @IBOutlet weak var namePairCurrency: UILabel!
    @IBOutlet weak var valuePipsLbl: UILabel!
    @IBOutlet weak var typeTransactionLbl: UILabel!
    @IBOutlet weak var capitalTf: UITextField!
    @IBOutlet weak var entryPointTf: UITextField!
    @IBOutlet weak var stopLoseTf: UITextField!
    @IBOutlet weak var takeProfitTf: UITextField!
    @IBOutlet weak var lotSizeTf: UITextField!
    @IBOutlet weak var maxAlowedLotLbl: UILabel!
    @IBOutlet weak var riskRateTf: UITextField!
    
    //
    @IBOutlet weak var stopLossLbl: UILabel!
    @IBOutlet weak var takeProfitLbl: UILabel!
    @IBOutlet weak var riskRewardRatioLbl: UILabel!
    @IBOutlet weak var amountRiskLbl: UILabel!
    @IBOutlet weak var amountGainLbl: UILabel!
    @IBOutlet weak var maxLotsLbl: UILabel!
    @IBOutlet weak var pipValueLbl: UILabel!
    
    //
    var typeTransactionPickerView = UIPickerView()
    //
    let createTransactionVM = CreateTransactionViewModel()
    let listPairCurrencyVM = ListPairCurrencyViewModel()
    var pairCurrency:PairCurrencyModel?
    var pipValue:Double = 0.0
    var mainPrice:Double = 0.0
    var amountBalance:Double = 0.0
    var riskRate:Double = 0.0
    var entryPrice:Double = 0.0
    var stopLossPrice:Double = 0.0
    var takeProfitPrice:Double = 0.0
    var amountToRisk:Double = 0.0
    var amountGain:Double = 0.0
    var maxStandardLot:Double = 0.0
    var maxLossAmount:Double = 0.0
    var riskRewardRatio:Double = 0.0
    var valueOfPip:Double = 0.0
    var lotSize:Double = 0.0
    var pipsLoss:Double = 0.0
    var pipsGain:Double = 0.0
    var typeTrading:TypeTransaction = TypeTransaction.Buy
    //
    var selectedTransaction:TransactionModel?
    var isEdit:Bool = false
    var isAddReason:Bool = false
    var dataImage:Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        reasionView.isHidden = true
        heightReasonView.constant = 0
        //
        entryPointTf.delegate = self
        stopLoseTf.delegate = self
        takeProfitTf.delegate = self
        capitalTf.delegate = self
        lotSizeTf.delegate = self
        riskRateTf.delegate = self
        descriptionTextView.delegate = self
        capitalTf.keyboardType = .decimalPad
        entryPointTf.keyboardType = .decimalPad
        stopLoseTf.keyboardType = .decimalPad
        takeProfitTf.keyboardType = .decimalPad
        lotSizeTf.keyboardType = .decimalPad
        riskRateTf.keyboardType = .decimalPad
        //
        descriptionTextView.text = "Enter your reason in here!"
        descriptionTextView.textColor = .lightGray
        //
        callAPIToGetListPairCurrencyAndCalculatePipValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Create Transaction"
    }
    //MARK: Ui Event
    
    @IBAction func addReasonButtonWasPressed(_ sender: Any) {
        if isAddReason == false{
            reasionView.isHidden = false
            heightReasonView.constant = 250
            isAddReason = true
        }else{
            reasionView.isHidden = true
            heightReasonView.constant = 0
            isAddReason = false
        }
    }
    
    @IBAction func uploadImageButtonWasPressed(_ sender: Any) {
        self.setupPhotoPicker()
    }
    @IBAction func choosePairCurrencyButtonWasPressed(_ sender: Any) {
        let targetVC = ListPairCurrencyViewController()
        targetVC.currentPairCurrency = namePairCurrency.text
        targetVC.delegate = self
        self.navigationController?.pushViewController(targetVC, animated: true)
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
        if !validate(){
            return
        }
        //
        var status:String?
        switch self.typeTransactionLbl.text {
        case "Buy", "Sell":
            status = StatusTransaction.Active.rawValue
        case "Buy Limit", "Sell Limit":
            status = StatusTransaction.Pending.rawValue
        default:
            break
        }
        var description:String?
        if descriptionTextView.textColor != UIColor.lightGray{
            description = descriptionTextView.text
        }
        HUD.show(.systemActivity)
        var ref:DocumentReference? = nil
        let db = Firestore.firestore()
        if isAddReason == true && dataImage != nil{ //upload image to firebase
            createTransactionVM.uploadImageToFrirebasestore(dataImage: dataImage!) { (success, imgUrl) in
                if success{
                    ref = db.collection("Transactions").addDocument(data: [
                        "dateCreate":HelperMethod.convertDateToString(date: Date(), dateFormater: "yyyy-MM-dd HH:mm:ss"),
                        "pairCurrency":self.pairCurrency?.name,
                        "groupCurrency":self.pairCurrency?.group,
                        "riskRate":self.riskRate,
                        "detail": [
                            "entryPoint":Double((self.entryPointTf.text?.digits())!),
                            "stopLossPoint":Double((self.stopLoseTf.text?.digits())!),
                            "takeProfitPoint":Double((self.takeProfitTf.text?.digits())!),
                            "lotSize":Double((self.lotSizeTf.text?.digits())!),
                            "pipsLoss":self.pipsLoss,
                            "pipsProfit":self.pipsGain,
                            "rewardMoney": self.amountGain,
                            "lossMoney":self.amountToRisk,
                            "RRRate":self.riskRewardRatioLbl.text,
                            "type": self.typeTransactionLbl.text,
                            "result": ResultTransaction.Unknow.rawValue,
                            "hasReason": 0,
                            "reasonDescription": description,
                            "chartImage": imgUrl,
                        ],
                        "userID":Constant.defaults.string(forKey: Constant.USER_ID),
                        "status":status,
                        "transactionID": UUID().uuidString,
                        "timeStamp": Timestamp(date: Date())

                    ], completion: { (error) in
                        if let err = error{
                            HelperMethod.showAlertWithMessage(message: "Error adding document: \(err)")
                        }else{
                            HelperMethod.showAlertWithMessage(message: "Create transaction successfully!")
                            print("Document added with ID: \(ref!.documentID)")
                        }
                        HUD.hide()
                    })
                }
            }
        }else{
            ref = db.collection("Transactions").addDocument(data: [
                "dateCreate":HelperMethod.convertDateToString(date: Date(), dateFormater: "yyyy-MM-dd HH:mm:ss"),
                "pairCurrency":self.pairCurrency?.name,
                "groupCurrency":self.pairCurrency?.group,
                "riskRate":self.riskRate,
                "detail": [
                    "entryPoint":Double((self.entryPointTf.text?.digits())!),
                    "stopLossPoint":Double((self.stopLoseTf.text?.digits())!),
                    "takeProfitPoint":Double((self.takeProfitTf.text?.digits())!),
                    "lotSize":Double((self.lotSizeTf.text?.digits())!),
                    "pipsLoss":self.pipsLoss,
                    "pipsProfit":self.pipsGain,
                    "rewardMoney": self.amountGain,
                    "lossMoney":self.amountToRisk,
                    "RRRate":self.riskRewardRatioLbl.text,
                    "type": self.typeTransactionLbl.text,
                    "result": ResultTransaction.Unknow.rawValue,
                    "hasReason": 0,
                    "reasonDescription": description,
                    "chartImage": nil,
                ],
                "userID":Constant.defaults.string(forKey: Constant.USER_ID),
                "status":status,
                "transactionID": UUID().uuidString,
                "timeStamp": Timestamp(date: Date())

            ], completion: { (error) in
                if let err = error{
                    HelperMethod.showAlertWithMessage(message: "Error adding document: \(err)")
                }else{
                    HelperMethod.showAlertWithMessage(message: "Create transaction successfully!")
                    print("Document added with ID: \(ref!.documentID)")
                }
                HUD.hide()
            })
        }
//        ref = db.collection("Transactions").addDocument(data: [
//            "dateCreate":HelperMethod.convertDateToString(date: Date(), dateFormater: "yyyy-MM-dd HH:mm:ss"),
//            "pairCurrency":self.pairCurrency?.name,
//            "groupCurrency":self.pairCurrency?.group,
//            "riskRate":self.riskRate,
//            "detail": [
//                "entryPoint":Double((self.entryPointTf.text?.digits())!),
//                "stopLossPoint":Double((self.stopLoseTf.text?.digits())!),
//                "takeProfitPoint":Double((self.takeProfitTf.text?.digits())!),
//                "lotSize":Double((self.lotSizeTf.text?.digits())!),
//                "pipsLoss":self.pipsLoss,
//                "pipsProfit":self.pipsGain,
//                "rewardMoney": self.amountGain,
//                "lossMoney":self.amountToRisk,
//                "RRRate":self.riskRewardRatioLbl.text,
//                "type": self.typeTransactionLbl.text,
//                "result": ResultTransaction.Unknow.rawValue
//            ],
//            "userID":Constant.defaults.string(forKey: Constant.USER_ID),
//            "status":status,
//            "transactionID": UUID().uuidString,
//            "timeStamp": Timestamp(date: Date())
//
//        ], completion: { (error) in
//            if let err = error{
//                HelperMethod.showAlertWithMessage(message: "Error adding document: \(err)")
//            }else{
//                HelperMethod.showAlertWithMessage(message: "Create transaction successfully!")
//                print("Document added with ID: \(ref!.documentID)")
//            }
//            HUD.hide()
//        })
        
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
    func callAPIToGetListPairCurrencyAndCalculatePipValue(){
        //Goi API lay danh sach tien te -> goi API lay gia hien tai
        listPairCurrencyVM.getListPairCurrency { (result, listPairCurrency) in
            if result == true{
                guard let list = listPairCurrency else {return}
                self.pairCurrency = list.first
                self.namePairCurrency.text = list.first?.name
                //Goi API lay gia hien tai
                self.createTransactionVM.convertCurrency(fromCurrency: (self.pairCurrency?.fromCurrency)!, toCurrency: (self.pairCurrency?.toCurrency)!) { (success, price) in
                    if success{
                        //Cap nhat lai gia
                        print(price)
                        guard let price = price else {return}
                        self.mainPrice = price
                        //Goi API tinh pip value
                        self.calculationPipValue(pairCurrency: self.pairCurrency!, volume: 100000) { (pipValue) in
                            print(pipValue)
                        }
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
            self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            completionHandler(valuePip)
        case "USD_XXX": //Trường hợp 2: Đối với các cặp tiền có USD đứng trước (USD/XXX): 1 pip = (0.0001/tỷ giá) USD
            valuePip = (0.0001/mainPrice)*volume
            self.valueOfPip = valuePip
            self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
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
                        self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                        self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
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
                        self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                        self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                        completionHandler(valuePip)
                    }
                }
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // Nếu XXX là USD thì trường hợp này quay về cách tính của trường hợp 2 (cặp tiền có USD đứng trước), lúc này, 1 pip = ( 0.01/tỷ giá) USD
                valuePip = (0.01/mainPrice)*volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                completionHandler(valuePip)
            }else{ //Nếu XXX không phải là USD thì sẽ quy về cách tính của trường hợp 3 (cặp tiền chéo không có USD) 1 pip = [(0.01/tỷ giá chính)*tỷ giá phụ] USD
                createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: "USD") { [self] (success, price) in
                    if success{
                        guard let subPrice = price else {return}
                        let value = (0.01/mainPrice)*subPrice
                        valuePip = value * volume
                        self.valueOfPip = valuePip
                        self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                        self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                        completionHandler(valuePip)
                    }
                }
            }
        case "XAU_USD":
            valuePip =  10.0
            self.valueOfPip = valuePip
            self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            completionHandler(valuePip)
        case "BTC_USD":
            valuePip =  0.1
            self.valueOfPip = valuePip
            self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
            completionHandler(valuePip)
            
        default:
            break
        }
    }
    //
    func calculateMaxLotAmountGainAmountLoss(pipValue:Double, balanceAmount:Double, riskRate:Double, entryPrice:Double, stopLossPrice:Double, takeProfitPrice:Double, pairCurrency:PairCurrencyModel){
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
        self.maxLossAmount = (balanceAmount * riskRate)/100
        self.maxStandardLot = maxLossAmount/(pipsLoss*pipValue)
        print(riskRate)
        print(maxStandardLot)
        self.amountToRisk = pipsLoss * pipValue * lotSize
        self.amountGain = pipsGain * pipValue * lotSize
        let riskRewardRatio = amountGain/amountToRisk
        //Update UI
        self.maxAlowedLotLbl.text = "*Maximum Alowed Lot: " + String(self.maxStandardLot.formaterValueOfPips()) + " Lots"
        self.maxLotsLbl.text = String(self.maxStandardLot.formaterValueOfPips()) + " Lots"
        self.stopLossLbl.text = String(Int(pipsLoss)) + " Pips"
        self.takeProfitLbl.text = String(Int(pipsGain)) + " Pips"
        self.riskRewardRatioLbl.text = "1/" + String(riskRewardRatio.formaterCurrentPriceWithTwoFractionDigits())
        self.amountGainLbl.text = String(self.amountGain.formaterCurrentPriceWithTwoFractionDigits()) + " $"
        self.amountRiskLbl.text = String(self.amountToRisk.formaterCurrentPriceWithTwoFractionDigits()) + " $"
    }
    //
    func calculation(){
        guard let pairCurrency = self.pairCurrency else {return}
        let balanceAmount = Double((capitalTf.text?.digits())!) ?? 0.0
        let riskRate = Double((riskRateTf.text?.digits())!) ?? 0.0
        let entryPrice = Double((entryPointTf.text?.digits())!) ?? 0.0
        let stopLossPrice = Double((stopLoseTf.text?.digits())!) ?? 0.0
        let takeProfitPrice = Double((takeProfitTf.text?.digits())!) ?? 0.0
        calculationPipValue(pairCurrency: pairCurrency, volume: 100000) { (pipValue) in
            self.calculateMaxLotAmountGainAmountLoss(pipValue: pipValue, balanceAmount: balanceAmount, riskRate: riskRate, entryPrice: entryPrice, stopLossPrice: stopLossPrice, takeProfitPrice: takeProfitPrice, pairCurrency: pairCurrency)
        }
    }
    //
    func getPriceOfPairCurrencyAndPipValue(pairCurrency:PairCurrencyModel){
        createTransactionVM.convertCurrency(fromCurrency: pairCurrency.fromCurrency!, toCurrency: pairCurrency.toCurrency!) { (success, price) in
            if success{
                //Cap nhat lai gia
                guard let price = price else {return}
                self.mainPrice = price
                //Call API tinh pip value
                self.calculationPipValue(pairCurrency: pairCurrency, volume: 100000) { (pipValue) in
                    print(pipValue)
                }
            }
        }
    }
    
    //
    func validate() -> Bool{
        if capitalTf.text == "" || capitalTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Plase enter your current balance.")
            return false
        }
        if riskRateTf.text == "" || riskRateTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your risk rate.")
            return false
        }
        if entryPointTf.text == "" || entryPointTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your entry price.")
            return false
        }
        if stopLoseTf.text == "" || stopLoseTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your stoploss price.")
            return false
        }
        if takeProfitTf.text == "" || takeProfitTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your take profit price.")
        }
        return true
    }
}
//MARK: ListPairCurrencyDelegate
extension CreateTransactionViewController: ListPairCurrencyDelegate{
    func passPairCurrencyData(pairCurrency: PairCurrencyModel) {
        self.pairCurrency = pairCurrency
        self.namePairCurrency.text = pairCurrency.name
        //
        self.getPriceOfPairCurrencyAndPipValue(pairCurrency: self.pairCurrency!)
        
    }
}
//MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension CreateTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.listTypeTransaction.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.listTypeTransaction[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeTransactionLbl.text = Constant.listTypeTransaction[row]
    }
    
    
}
//MARK:
extension CreateTransactionViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == entryPointTf || textField == stopLoseTf || textField == takeProfitTf{
            if textField.text?.first == "."{
                textField.text = nil
            }
            //real-time formate input
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
            //Calculation in here
            self.calculation()
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
            //Calculation in here
            self.calculation()
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
            self.lotSize = Double((lotSizeTf.text?.replacingOccurrences(of: ",", with: ""))!) ?? 0.0
            //Calculation in here
            self.calculation()
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
            //Calculation in here
            self.calculation()
        }
    }
    ///
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == capitalTf{
            if textField.text == nil || textField.text == ""{
                textField.text = nil
            }else{
                textField.text = textField.text! + " $"
            }
        }
        if textField == riskRateTf{
            if textField.text == nil || textField.text == ""{
                textField.text = nil
            }else{
                textField.text = textField.text! + " %"
            }
        }
    }
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == riskRateTf{
            let nsString = NSString(string: textField.text!)
            let newText = nsString.replacingCharacters(in: range, with: string)
            let valueInput = Double(newText.replacingOccurrences(of: ",", with: "")) ?? 0.0
            
            return valueInput >= 0 && valueInput <= 100
        }
        if textField == lotSizeTf{
            let nsString = NSString(string: textField.text!)
            let newText = nsString.replacingCharacters(in: range, with: string)
            let valueInput = Double(newText.replacingOccurrences(of: ",", with: "")) ?? 0.0
            
            return valueInput <= maxStandardLot || newText == nil || newText == ""
        }
        return true
    }
}
//MARK: UITextViewDelegate
extension CreateTransactionViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.2117647059, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Enter your reason in here!"
            textView.textColor = .lightGray
        }
    }
}
extension CreateTransactionViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicker = info[.originalImage] as! UIImage
        self.chartImageView.image = imagePicker
        //
        self.dataImage = imagePicker.jpegData(compressionQuality: 0.4)
        self.dismiss(animated: true, completion: nil)
    }
}
