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
    
    @IBOutlet weak var infomationTitle: UILabel!
    @IBOutlet weak var chooseCurrencyTitle: UILabel!
    @IBOutlet weak var valuePipTitle: UILabel!
    @IBOutlet weak var balanceAccountTitle: UILabel!
    @IBOutlet weak var riskRateTitle: UILabel!
    @IBOutlet weak var setupTransactionTitle: UILabel!
    @IBOutlet weak var chooseTypeTransactionTitle: UILabel!
    @IBOutlet weak var entryPriceTitle: UILabel!
    @IBOutlet weak var stopLossPriceTitle: UILabel!
    @IBOutlet weak var takeProfitPriceTitle: UILabel!
    @IBOutlet weak var lotSizeTitle: UILabel!
    @IBOutlet weak var reasonTitle: UILabel!
    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var stopLossAtTitle: UILabel!
    @IBOutlet weak var takeProfitAtTitle: UILabel!
    @IBOutlet weak var amountLossTitle: UILabel!
    @IBOutlet weak var amountGainTitle: UILabel!
    @IBOutlet weak var riskRewardRatioTitle: UILabel!
    @IBOutlet weak var maxLotTitle: UILabel!
    @IBOutlet weak var pipValueTitle: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    
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
    var subPrice:Double = 0.0
    var amountBalance:Double = 0.0
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
        setupUI()
        //
        self.viewModelCallBack()
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
        descriptionTextView.text = "Enter your reason in here!".localized()
        descriptionTextView.textColor = .lightGray
        //
        callAPIToGetListPairCurrencyAndCalculatePipValue()
        //

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Create Transaction".localized()
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
        let alert = UIAlertController(title: "Select Your Type Transaction".localized(), message: "\n\n\n\n\n", preferredStyle: .actionSheet)
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
                        "riskRate":Double((self.riskRateTf.text?.digits())!),
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
                            "hasReason": 1,
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
                "riskRate":Double((self.riskRateTf.text?.digits())!),
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
        
    }
    //MARK: Helper Method
    func setupUI(){
        infomationTitle.text = "Infomation".localized()
        chooseCurrencyTitle.text = "Choose Your Pair Currency".localized()
        valuePipTitle.text = "Value Pips/Standard Lot".localized()
        balanceAccountTitle.text = "Balance Account".localized()
        capitalTf.placeholder = "Enter your balance account".localized()
        riskRateTitle.text = "Risk Rate".localized()
        riskRateTf.placeholder = "Enter your risk rate".localized()
        setupTransactionTitle.text = "Setup Transaction".localized()
        chooseTypeTransactionTitle.text = "Choose Type Transaction".localized()
        entryPriceTitle.text = "Entry Price".localized()
        entryPointTf.placeholder = "Enter your entry point".localized()
        stopLossPriceTitle.text = "Stop Loss Price".localized()
        stopLoseTf.placeholder = "Enter your stop loss point".localized()
        takeProfitPriceTitle.text = "Take Profit Price".localized()
        takeProfitTf.placeholder = "Enter your take profit point".localized()
        lotSizeTitle.text = "Lot Size".localized()
        lotSizeTf.placeholder = "Enter your volume".localized()
        reasonTitle.text = "Reason".localized()
        summaryTitle.text = "Summary".localized()
        stopLossAtTitle.text = "Stop Loss at".localized()
        takeProfitAtTitle.text = "Take Profit at".localized()
        amountLossTitle.text = "Amount Loss".localized()
        amountGainTitle.text = "Amount Gain".localized()
        riskRewardRatioTitle.text = "Risk Reward Ratio".localized()
        maxLotTitle.text = "Max Lots".localized()
        pipValueTitle.text = "Pip Value".localized()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        createButton.setTitle("Create".localized(), for: .normal)
        maxAlowedLotLbl.text = "Maximum Alowed Lot".localized() + "-"
    }
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
                //Goi API lay mainprice -> goi API lay sub price -> calculationPipValue
                self.getMainPrice(pairCurrency: self.pairCurrency!) { success in
                    if success{
                        self.getSubPrice(pairCurrency: self.pairCurrency!) { success in
                            if success{
                                self.calculationPipValue(pairCurrency: self.pairCurrency!, volume: 100000) { (pipValue) in
                                    print(pipValue)
                                }
                            }
                        }
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
            case "USD/CAD", "USD/CHF", "USD/CZK", "USD/DKK", "USD/HUF", "USD/JPY", "USD/MXN", "USD/NOK", "USDP/LN", "USD/SEK", "USD/SGD", "USD/TRY", "USD/ZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD:
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
            case "USD/CAD", "USD/CHF", "USD/CZK", "USD/DKK", "USD/HUF", "USD/JPY", "USD/MXN", "USD/NOK", "USD/PLN", "USD/SEK", "USD/SGD", "USD/TRY", "USD/ZAR": //Nhưng nếu cặp tỷ giá phụ có USD đứng trước thì: 1 pip = [(0.0001/tỷ giá chính)/tỷ giá phụ] USD
                let value = (0.0001/mainPrice)/subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                completionHandler(valuePip)
                
            default: //1 pip = [(0.0001/tỷ giá chính)*tỷ giá phụ] USD
                let value = (0.0001/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                completionHandler(valuePip)
            }
        case "XXX_JPY":
            if pairCurrency.name?.contains("USD") == true{ // Nếu XXX là USD thì trường hợp này quay về cách tính của trường hợp 2 (cặp tiền có USD đứng trước), lúc này, 1 pip = ( 0.01/tỷ giá) USD
                valuePip = (0.01/mainPrice)*volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                completionHandler(valuePip)
            }else{ //Nếu XXX không phải là USD thì sẽ quy về cách tính của trường hợp 3 (cặp tiền chéo không có USD) 1 pip = [(0.01/tỷ giá chính)*tỷ giá phụ] USD
                let value = (0.01/mainPrice)*subPrice
                valuePip = value * volume
                self.valueOfPip = valuePip
                self.pipValueLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                self.valuePipsLbl.text = String(valuePip.formaterValueOfPips()) + " $"
                completionHandler(valuePip)
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
        self.maxAlowedLotLbl.text = "Maximum Alowed Lot".localized() + String(self.maxStandardLot.formaterValueOfPips()) + " Lots"
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
        //Goi API lay mainprice -> goi API lay sub price -> calculationPipValue
        self.getMainPrice(pairCurrency: self.pairCurrency!) { success in
            if success{
                self.getSubPrice(pairCurrency: self.pairCurrency!) { success in
                    if success{
                        self.calculationPipValue(pairCurrency: self.pairCurrency!, volume: 100000) { (pipValue) in
                            print(pipValue)
                        }
                    }
                }
            }
        }
    }
    
    //
    func validate() -> Bool{
        if capitalTf.text == "" || capitalTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Plase enter your current balance.".localized())
            return false
        }
        if riskRateTf.text == "" || riskRateTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your risk rate.".localized())
            return false
        }
        if entryPointTf.text == "" || entryPointTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your entry price.".localized())
            return false
        }
        if stopLoseTf.text == "" || stopLoseTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your stoploss price.".localized())
            return false
        }
        if takeProfitTf.text == "" || takeProfitTf.text == nil{
            HelperMethod.showAlertWithMessage(message: "Please enter your take profit price.".localized())
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
//MARK: UITextFieldDelegate
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
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == riskRateTf{
            if string == ","{
                textField.text = textField.text! + "."
                return false
            }
            //
            let nsString = NSString(string: textField.text!)
            let newText = nsString.replacingCharacters(in: range, with: string)
            let valueInput = Double(newText.replacingOccurrences(of: ",", with: "")) ?? 0.0
            
            return valueInput >= 0 && valueInput <= 100
        }
        if textField == lotSizeTf{
            if string == ","{
                textField.text = textField.text! + "."
                return false
            }
            //
            let nsString = NSString(string: textField.text!)
            let newText = nsString.replacingCharacters(in: range, with: string)
            let valueInput = Double(newText.replacingOccurrences(of: ",", with: "")) ?? 0.0
            
            return valueInput <= maxStandardLot || newText == nil || newText == ""
        }
        //
        if string == ","{
            textField.text = textField.text! + "."
            return false
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
            textView.text = "Enter your reason in here!".localized()
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
