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
class DashboardViewController: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var activeTransactionCollectionView: UICollectionView!
    @IBOutlet weak var emptyTransactionView: CustomeBoderRadiusView!
    @IBOutlet weak var durationTimeSegment: UISegmentedControl!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var winLbl: UILabel!
    @IBOutlet weak var lossLbl: UILabel!
    @IBOutlet weak var totalAmountMoneyLbl: UILabel!
    @IBOutlet weak var icImageView: UIImageView!
    //
    let dashboardVM = DashboardViewModel()
    var listActiveTransaction:[TransactionModel] = []
    var fromDate:Date?
    var toDate:Date?
    var numberOfWin:Int = 0
    var numberOfLoss:Int = 0
    var winAmount:Double = 0
    var lossAmount:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let user = Auth.auth().currentUser
        print(user?.email)
        print(user?.uid)
        print(user?.displayName)
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
        avatarImg.layer.cornerRadius = 15
        avatarImg.clipsToBounds = true
        self.getUserInfoAndUpdateUI()
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
    
    @IBAction func createTransactionWasPressed(_ sender: Any) {
        let targetVC = CreateTransactionViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func manageTransactionWasPressed(_ sender: Any) {
        let targetVC = ManageTransactionViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func economicNewsButtonWasPressed(_ sender: Any) {
        let targetVC = HomeNewsViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func economicCalenderButtonWasPressed(_ sender: Any) {
        let targetVC = EconomicNewsViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func longShortRatioButtonWasPressed(_ sender: Any) {
        let targetVC = LongShortRatioViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    @IBAction func durationTimeSegmentWasPressed(_ sender: Any) {
        print(durationTimeSegment.selectedSegmentIndex)
        switch durationTimeSegment.selectedSegmentIndex {
        case 0:
            print("Date")
            self.toDate = Date()
            self.fromDate = Calendar.current.date(byAdding: .day, value: -1, to: toDate!)
        case 1:
            print("Month")
            self.toDate = Date()
            self.fromDate = Calendar.current.date(byAdding: .month, value: -1, to: toDate!)
        case 2:
            print("Year")
            self.toDate = Date()
            self.fromDate = Calendar.current.date(byAdding: .year, value: -1, to: toDate!)
        case 3:
            print("Other")
        default:
            break
        }
        //
        durationLbl.text = (fromDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))! + " - " + (toDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))!
        //
        self.calculationWinLoss(fromDate: fromDate!, toDate: toDate!)
    }
    //MARK: Helper Method
    
    private func viewModelCallBack(){
        dashboardVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        dashboardVM.afterApiCall = {
            HUD.hide()
        }
    }
    
    func setupDurationTimeDefault(){
        self.fromDate = Date()
        self.toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate!)
        durationLbl.text = (fromDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))! + " - " + (toDate?.dateToString(format: DateformatterType.DD_MM_YYYY_Slash.rawValue))!
    }
    
    func calculationWinLoss(fromDate:Date, toDate:Date){
        dashboardVM.getListTransactionByDate(startDate: fromDate, toDate: toDate) { [self] (success, response) in
            if success{
                print(response?.count)
                numberOfLoss = 0
                numberOfWin = 0
                winAmount = 0
                lossAmount = 0
                guard let transactions = response else {return}
                for eachTransaction in transactions{
                    if eachTransaction.detail?.result?.uppercased() == ResultTransaction.Win.rawValue.uppercased(){
                        numberOfWin += 1
                        //Calculate win amount
                        winAmount += eachTransaction.detail?.rewardMoney ?? 0
                    }else if eachTransaction.detail?.result?.uppercased() == ResultTransaction.Loss.rawValue.uppercased(){
                        numberOfLoss += 1
                        //Calculate loss amount
                        lossAmount += eachTransaction.detail?.lossMoney ?? 0
                    }
                }
                winLbl.text = String(numberOfWin)
                lossLbl.text = String(numberOfLoss)
                if winAmount > lossAmount{
                    let amount = winAmount - lossAmount
                    totalAmountMoneyLbl.text = "+ " + amount.formaterCurrentPriceWithTwoFractionDigits() + "$"
                    icImageView.image = UIImage(named: "growingMoneyIcon")
                }else if winAmount < lossAmount{
                    let amount = lossAmount - winAmount
                    totalAmountMoneyLbl.text = "- " + amount.formaterCurrentPriceWithTwoFractionDigits() + "$"
                    icImageView.image = UIImage(named: "lossMoneyIcon")
                }else{
                    totalAmountMoneyLbl.text = "0.00$"
                    icImageView.image = UIImage(named: "growingMoneyIcon")
                }
            }
        }
    }
    //
    func getUserInfoAndUpdateUI(){
        guard let uid = Constant.defaults.string(forKey: Constant.USER_ID) else {return}
        print(uid)
        dashboardVM.getUserInfoByUserID(userID: uid) { (success, userInfo) in
            self.userNameLbl.text = userInfo?.fullName?.capitalized
            if let urlImage = userInfo?.avatarImg{
                self.avatarImg.kf.setImage(with: URL(string: urlImage))
            }
        }
    }
}

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
    
}
