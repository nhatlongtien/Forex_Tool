//
//  DashboardViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import PKHUD
import BetterSegmentedControl
import SwiftUI
import Localize_Swift
class DashboardViewController: UIViewController {
    @IBOutlet weak var noActiveTransactionTitle: UILabel!
    @IBOutlet weak var createButtonTitle: UIButton!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var statisticTitle: UILabel!
    @IBOutlet weak var calculationToolTitle: UILabel!
    @IBOutlet weak var createTransactionTitle: UILabel!
    @IBOutlet weak var manageTransactionTitle: UILabel!
    @IBOutlet weak var economicNewsTitle: UILabel!
    @IBOutlet weak var economicCalendarTitle: UILabel!
    @IBOutlet weak var marketTitle: UILabel!
    @IBOutlet weak var rewardTitle: UILabel!
    @IBOutlet weak var riskTitle: UILabel!
    @IBOutlet weak var overallTitle: UILabel!
    @IBOutlet weak var numberTradingTitle: UILabel!
    @IBOutlet weak var winLossRatioTitle: UILabel!
    @IBOutlet weak var analysisTitle: UILabel!
    
    //
    @IBOutlet weak var notifiImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var userNameLbl: UILabel!
//    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var activeTransactionCollectionView: UICollectionView!
    @IBOutlet weak var emptyTransactionView: CustomeBoderRadiusView!
    @IBOutlet weak var durationTimeSegment: UISegmentedControl!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var numberWinLbl: UILabel!
    @IBOutlet weak var numberLossLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var pipsGainLbl: UILabel!
    @IBOutlet weak var pipsLossLbl: UILabel!
    @IBOutlet weak var amountGainLbl: UILabel!
    @IBOutlet weak var amountLossLbl: UILabel!
    @IBOutlet weak var totalNumberTradingLbl: UILabel!
    @IBOutlet weak var winLossPercentLbl: UILabel!
    //
    let dashboardVM = DashboardViewModel()
    var listActiveTransaction:[TransactionModel] = []
    var fromDate:Date?
    var toDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModelCallBack()
        scrollView.delegate = self
        //
        setupUI()
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        activeTransactionCollectionView.collectionViewLayout = layout
        let nibCell = UINib(nibName: "ActiveTransactionCollectionViewCell", bundle: nil)
        activeTransactionCollectionView.register(nibCell, forCellWithReuseIdentifier: "ActiveTransactionCollectionViewCell")
        activeTransactionCollectionView.delegate = self
        activeTransactionCollectionView.dataSource = self
        //
        //self.userNameLbl.text = user?.displayName
//        avatarImg.layer.cornerRadius = 15
//        avatarImg.clipsToBounds = true
//        self.getUserInfoAndUpdateUI()
        //
        self.setupDurationTimeDefault()
        //
        dashboardVM.getConfig()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        Constant.isInTabBarControll = false
        //Get listActiveTransaction
        self.listActiveTransaction = []
        dashboardVM.getListTransaction(isFillter: true, fromDate: nil, toDate: nil, statusTransaction: "Active", resultTransaction: nil) { [self] (success, response) in
            if success{
                guard let listTransaction = response else {return}
                self.listActiveTransaction = listTransaction
                if listActiveTransaction.count == 0{
                    self.emptyTransactionView.isHidden = false
                }else{
                    self.emptyTransactionView.isHidden = true
                }
                activeTransactionCollectionView.reloadData()
            }
        }
        //
        self.calculationWinLoss(fromDate: fromDate!, toDate: toDate!)
    }

    //MARK: Ui Event
    
    @IBAction func notificationButtonWasPressed(_ sender: Any) {
        let targetVC = HomeNotificationViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func calculaorButtonWasPressed(_ sender: Any) {
        let targetVC = HomeCalculationViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func createTransactionWasPressed(_ sender: Any) {
        let targetVC = CreateTransactionViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func manageTransactionWasPressed(_ sender: Any) {
        let targetVC = ManageTransactionViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func economicNewsButtonWasPressed(_ sender: Any) {
        let targetVC = HomeNewsViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func economicCalenderButtonWasPressed(_ sender: Any) {
        let targetVC = EconomicCalendarViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
//    @IBAction func longShortRatioButtonWasPressed(_ sender: Any) {
//        let targetVC = LongShortRatioViewController()
//        self.navigationController?.pushViewController(targetVC, animated: true)
//    }
    @IBAction func marketButtonWasPressed(_ sender: Any) {
        let targetVC = HomeMarketViewController()
        targetVC.isFromTabbar = false
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func analysisButtonWasPressed(_ sender: Any) {
        //
        let targetVC = AnalysisViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func durationTimeSegmentWasPressed(_ sender: Any) {
        print(durationTimeSegment.selectedSegmentIndex)
        switch durationTimeSegment.selectedSegmentIndex {
        case 0:
            print("Week")
            self.fromDate = Date().startOfWeek
            self.toDate = Date().endOfWeek
        case 1:
            print("Month")
            self.fromDate = Date().startOfMonth
            self.toDate = Date().endOfMonth
        case 2:
            print("Year")
            self.fromDate = Date().startOfYear
            self.toDate = Date().endOfYear
        case 3:
            print("Other")
            let targetVC = DatePickerPopupViewController()
            targetVC.delegate = self
            targetVC.modalPresentationStyle = .custom
            self.present(targetVC, animated: true, completion: nil)
            
        default:
            break
        }
        //
        durationLbl.text = (fromDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))! + " - " + (toDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))!
        //
        self.calculationWinLoss(fromDate: fromDate!, toDate: toDate!)
    }
    //MARK: Helper Method
    func setupUI(){
        noActiveTransactionTitle.text = "No available active transaction in here, please create your first active transaction!".localized()
        createButtonTitle.setTitle("Create".localized(), for: .normal)
        featureTitle.text = "Features".localized()
        statisticTitle.text = "Statistics".localized()
        calculationToolTitle.text = "Calculator Tool".localized()
        createTransactionTitle.text = "Create Transaction".localized()
        manageTransactionTitle.text = "Manage Transaction".localized()
        economicNewsTitle.text = "Economic News".localized()
        economicCalendarTitle.text = "Economic Calendar".localized()
        marketTitle.text = "Market".localized()
        analysisTitle.text = "Analysis & Opinion".localized()
        rewardTitle.text = "Reward:".localized()
        riskTitle.text = "Risk:".localized()
        overallTitle.text = "Overall".localized()
        numberTradingTitle.text = "No. Trading:".localized()
        winLossRatioTitle.text = "Win/Loss:".localized()
        durationTimeSegment.setTitle("Week".localized(), forSegmentAt: 0)
        durationTimeSegment.setTitle("Month".localized(), forSegmentAt: 1)
        durationTimeSegment.setTitle("Week".localized(), forSegmentAt:  2)
        durationTimeSegment.setTitle("Other".localized(), forSegmentAt: 3)
        //
        customSegmentControl()
        
    }
    
    //
    private func viewModelCallBack(){
        dashboardVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        dashboardVM.afterApiCall = {
            HUD.hide()
        }
    }
    
    func setupDurationTimeDefault(){
        self.fromDate = Date().startOfWeek
        self.toDate = Date().endOfWeek
        durationLbl.text = (fromDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))! + " - " + (toDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))!
    }
    
    func calculationWinLoss(fromDate:Date, toDate:Date){
        var numberOfWin:Int = 0
        var numberOfLoss:Int = 0
        var winAmount:Double = 0
        var lossAmount:Double = 0
        var pipsGain:Double = 0
        var pipsLoss:Double = 0
        dashboardVM.getListTransactionByDate(startDate: fromDate, toDate: toDate) { [self] (success, response) in
            if success{
                print(response?.count)
                guard let transactions = response else {return}
                for eachTransaction in transactions{
                    if eachTransaction.detail?.result?.uppercased() == ResultTransaction.Win.rawValue.uppercased(){
                        numberOfWin += 1
                        //Calculate win amount
                        winAmount += eachTransaction.detail?.rewardMoney ?? 0
                        pipsGain += eachTransaction.detail?.pipsProfit ?? 0
                    }else if eachTransaction.detail?.result?.uppercased() == ResultTransaction.Loss.rawValue.uppercased(){
                        numberOfLoss += 1
                        //Calculate loss amount
                        lossAmount += eachTransaction.detail?.lossMoney ?? 0
                        pipsLoss += eachTransaction.detail?.pipsLoss ?? 0
                    }
                }
                numberWinLbl.text = String(numberOfWin)
                numberLossLbl.text = String(numberOfLoss)
                pipsGainLbl.text = pipsGain.formaterValueOfPips()
                pipsLossLbl.text = pipsLoss.formaterValueOfPips()
                amountGainLbl.text = winAmount.formaterCurrentPriceWithTwoFractionDigits() + "$"
                amountLossLbl.text = lossAmount.formaterCurrentPriceWithTwoFractionDigits() + "$"
                let total = numberOfWin + numberOfLoss
                totalNumberTradingLbl.text = String(total)
                if total != 0{
                    let winRatio = (Double(numberOfWin)/Double(total))*100
                    winLossPercentLbl.text = String(winRatio.numberFractionDigits(number: 0)) + "%"
                }else{
                    winLossPercentLbl.text = "-"
                    totalNumberTradingLbl.text = "-"
                }
                if winAmount > lossAmount{
                    let amount = winAmount - lossAmount
                    incomeLbl.text = "+ " + amount.formaterCurrentPriceWithTwoFractionDigits() + "$"
                }else if winAmount < lossAmount{
                    let amount = lossAmount - winAmount
                    incomeLbl.text = "- " + amount.formaterCurrentPriceWithTwoFractionDigits() + "$"
                }else{
                    incomeLbl.text = "0$"
                }
            }
        }
    }
    //
//    func getUserInfoAndUpdateUI(){
//        guard let uid = Constant.defaults.string(forKey: Constant.USER_ID) else {return}
//        print(uid)
//        dashboardVM.getUserInfoByUserID(userID: uid) { (success, userInfo) in
//            self.userNameLbl.text = userInfo?.fullName?.capitalized
//            let url = userInfo?.avatarImg
//            if url != nil && url != ""{
//                self.avatarImg.kf.setImage(with: URL(string: url!))
//            }else{
//                self.avatarImg.image = UIImage(named: "userIcon")
//            }
//        }
//    }
    //
    func customSegmentControl(){
        if #available(iOS 13.0, *){
            durationTimeSegment.backgroundColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
            durationTimeSegment.selectedSegmentTintColor = .white
            let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            durationTimeSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
            durationTimeSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }else{
            durationTimeSegment.tintColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
            durationTimeSegment.selectedSegmentTintColor = .white
            let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            durationTimeSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
            durationTimeSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }
    }
}
//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension DashboardViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listActiveTransaction.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = activeTransactionCollectionView.dequeueReusableCell(withReuseIdentifier: "ActiveTransactionCollectionViewCell", for: indexPath) as! ActiveTransactionCollectionViewCell
        if indexPath.row % 2 != 0{
            cell.backGroundView.backgroundColor = #colorLiteral(red: 1, green: 0.5294117647, blue: 0.06274509804, alpha: 1)
        }else{
            cell.backGroundView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.368627451, blue: 0.9490196078, alpha: 1)
        }
        cell.configCell(transaction: listActiveTransaction[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 265, height: 139)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetVC = DetailTransactionViewController()
        targetVC.selectedTransactionItem = listActiveTransaction[indexPath.row]
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
}
//MARK: DatePickerPopupViewControllerDelegate
extension DashboardViewController:DatePickerPopupViewControllerDelegate{
    func passData(fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
        durationLbl.text = (fromDate.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue)) + " - " + (toDate.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))
        //
        self.calculationWinLoss(fromDate: fromDate, toDate: toDate)
    }
}
//MARK:
extension DashboardViewController:UIScrollViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = -scrollView.contentInset.top
    }
}
