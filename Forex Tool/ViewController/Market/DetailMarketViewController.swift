//
//  DetailMarketViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/10/2021.
//

import UIKit
import PKHUD
import Localize_Swift
import DropDown
class DetailMarketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //
    var infoPairCurrency:PricePairCurrencyModel?
    //
    let headerView = DetailMarketHeaderView()
    let detailMarketVM = DetailMarketViewModel()
    var fromDate:String? = "2021-10-06"
    var toDate:String? = "2021-10-07"
    var listInfoEconomicCalendar:[EconomicCalendarModel] = []
    var durationTimes = [DurationTime.today.rawValue, DurationTime.tomorrow.rawValue, DurationTime.thisWeek.rawValue]
    let durationDropdown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModelCallBack()
        //
        headerView.deleate = self
        //
        let basicInfoCell = UINib(nibName: "BasicInfoTableViewCell", bundle: nil)
        let calenderCell = UINib(nibName: "EconomicCalenderTableViewCell", bundle: nil)
        tableView.register(basicInfoCell, forCellReuseIdentifier: "BasicInfoTableViewCell")
        tableView.register(calenderCell, forCellReuseIdentifier: "EconomicCalenderTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //
        DropDown.setupDefaultAppearance()
        setupDurationDropDown()
        //
        let fromDate = Date()
        let toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)
        self.fromDate = fromDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
        self.toDate = toDate!.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = infoPairCurrency?.symbol
        //
        detailMarketVM.getEconomicCalendar(symbol: (infoPairCurrency?.symbol?.replacingOccurrences(of: "/", with: ","))!, fromDate: fromDate!, toDate: toDate!) { success, listInfoEconomicCalendar in
            if success == true{
                self.listInfoEconomicCalendar = []
                guard let list = listInfoEconomicCalendar else {return}
                for item in list{
                    if item.importance != "0"{ //Khong lay nhung tin co do quan trong 1 *
                        self.listInfoEconomicCalendar.append(item)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    //MARK: Helper Method
    func setupDurationDropDown(){
        durationDropdown.anchorView = headerView.durationLbl
        durationDropdown.dataSource = self.durationTimes
        durationDropdown.selectionAction = { [self](index, item) in
            switch item {
            case DurationTime.today.rawValue:
                print("Today")
                let fromDate = Date()
                let toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)
                self.fromDate = fromDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
                self.toDate = toDate!.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
//                print(self?.fromDate)
//                print(self?.toDate)
            case DurationTime.tomorrow.rawValue:
                print("Tomorrow")
                let fromDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                let toDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate!)
                self.fromDate = fromDate!.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
                self.toDate = toDate!.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
//                print(self?.fromDate)
//                print(self?.toDate)
            case DurationTime.thisWeek.rawValue:
                let fromDate = Date().startOfWeek
                let toDate = Date().endOfWeek
                self.fromDate = fromDate!.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
                self.toDate = toDate!.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue)
//                print(self?.fromDate)
//                print(self?.toDate)
            default:
                break
            }
            self.headerView.durationLbl.text = item
            //
            detailMarketVM.getEconomicCalendar(symbol: (infoPairCurrency?.symbol?.replacingOccurrences(of: "/", with: ","))!, fromDate: fromDate!, toDate: toDate!) { success, listInfoEconomicCalendar in
                if success == true{
                    guard let list = listInfoEconomicCalendar else {return}
                    self.listInfoEconomicCalendar = []
                    self.listInfoEconomicCalendar = list
                    self.tableView.reloadData()
                }
            }
        }
    }
    func viewModelCallBack(){
        detailMarketVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        detailMarketVM.afterApiCall = {
            HUD.hide()
        }
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension DetailMarketViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 7
        }
        if section == 1{
            return listInfoEconomicCalendar.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoTableViewCell", for: indexPath) as! BasicInfoTableViewCell
            switch indexPath.row {
            case 0:
                cell.titleLbl.text = "Open Price:"
                cell.valueLbl.text = infoPairCurrency?.open
            case 1:
                cell.titleLbl.text = "High:"
                cell.valueLbl.text = infoPairCurrency?.high
            case 2:
                cell.titleLbl.text = "Low:"
                cell.valueLbl.text = infoPairCurrency?.low
            case 3:
                cell.titleLbl.text = "Current Price:"
                cell.valueLbl.text = infoPairCurrency?.currentPrice
            case 4:
                cell.titleLbl.text = "Change Points:"
                cell.valueLbl.text = infoPairCurrency?.changeInDayCandle
            case 5:
                cell.titleLbl.text = "Change Percent:"
                cell.valueLbl.text = infoPairCurrency?.changeInPercentage
            case 6:
                cell.titleLbl.text = "Time Update:"
                let time = infoPairCurrency?.time?.formartDate(inputFormat: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue)
                let timeStr = time?.dateToString(format: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue)
                cell.valueLbl.text = timeStr
            default:
                break
            }
            return cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EconomicCalenderTableViewCell", for: indexPath) as! EconomicCalenderTableViewCell
            cell.configCell(item: listInfoEconomicCalendar[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let view = DetailMarketHeaderView()
            view.durationView.isHidden = true
            return view
        }
        if section == 1{
            headerView.titleLbl.text = "ECONOMIC CALENDAR"
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            let size = CGSize(width: self.view.frame.width - 122, height: 1000)
            let item = listInfoEconomicCalendar[indexPath.row]
            let preditSentence = "Actual: \(item.actual!) | Forcast: \(item.forecast!) | Previous: \(item.previous!)"
            let estimateFrameForTitle = NSString(string: item.title!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Medium", size: 14)], context: nil)
            let estimateFrameForPreditSentence = NSString(string: preditSentence).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 14)], context: nil)
            let height = 35.5 + estimateFrameForTitle.height + estimateFrameForPreditSentence.height
            print(estimateFrameForPreditSentence.height)
            return height
        }
        return 40
    }
    
}
//MARK:
extension DetailMarketViewController: DetailMarketHeaderViewDelegate{
    func chooseDurationTimeDidTap() {
        durationDropdown.show()
    }
}
