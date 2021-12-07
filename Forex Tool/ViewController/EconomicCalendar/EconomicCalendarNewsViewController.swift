//
//  EconomicCalendarNewsViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 05/12/2021.
//

import UIKit
import PKHUD
class EconomicCalendarNewsViewController: BaseViewController {
    @IBOutlet weak var allTitle: UILabel!
    @IBOutlet weak var importantTitle: UILabel!
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    //
    var listDaysOfMonth = Date().daysOfMonth
    var isAll = true
    let calendarVM = CalendarEconomicViewModel()
    var listCalendars = [ReverseCalendarEconomicModel]()
    var selectDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        allTitle.text = "All".localized()
        importantTitle.text = "Important".localized()
        //
        viewModelCallBack()
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.collectionViewLayout = layout
        let nibCell = UINib(nibName: "EconomicCalendarCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "EconomicCalendarCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        //
        let nibTableCell = UINib(nibName: "CalendarTableViewCell", bundle: nil)
        tableView.register(nibTableCell, forCellReuseIdentifier: "CalendarTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //
        importantButton.setImage(UIImage(named: "grayCircle"), for: .normal)
        importantTitle.textColor = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Economic Calendars".localized()
        //
        let indexOfItem = listDaysOfMonth.firstIndex{$0.dateToString(format: DateformatterType.DD_MM_YYYY.rawValue) == Date().dateToString(format: DateformatterType.DD_MM_YYYY.rawValue)}
        let indexPath = IndexPath(row: Int(indexOfItem!), section: 0)
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.isSelected = true
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        //
        callAPIToGetCalendar(important: 0, date: selectDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue))
    }
    //MARK: UI Event
    @IBAction func allButtonWasPressed(_ sender: Any) {
        isAll = true
        allButton.setImage(UIImage(named: "greenCircle"), for: .normal)
        allTitle.textColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
        importantButton.setImage(UIImage(named: "grayCircle"), for: .normal)
        importantTitle.textColor = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        //
        callAPIToGetCalendar(important: 0, date: selectDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue))
    }
    
    @IBAction func importantButtonWasPressed(_ sender: Any) {
        isAll = false
        allButton.setImage(UIImage(named: "grayCircle"), for: .normal)
        allTitle.textColor = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        importantButton.setImage(UIImage(named: "greenCircle"), for: .normal)
        importantTitle.textColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
        //
        callAPIToGetCalendar(important: 1, date: selectDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue))
    }
    //MARK: Helper Method
    func viewModelCallBack(){
        calendarVM.beforeApiCall = {
            HUD.show(.systemActivity)
        }
        calendarVM.afterApiCall = {
            HUD.hide()
        }
    }
    func callAPIToGetCalendar(important:Int, date:String){
        calendarVM.getCalenderEconomic(important: important, date: date) { success, calendars in
            if success{
                self.listCalendars = []
                guard let calendars = calendars else {return}
                for item in calendars{
                    if item.events_id != 0{ //event
                        let calendar = ReverseCalendarEconomicModel(
                            id: item.events_id!,
                            previous: nil,
                            consensus: nil,
                            actual: nil,
                            star: item.star,
                            revised: nil,
                            translate: nil,
                            influence: nil,
                            economics_id: nil,
                            pub_time: item.pub_time,
                            country_flag: item.country_flag,
                            current_date: item.pub_time_tz,
                            events_translate: item.events_translate)
                        self.listCalendars.append(calendar)
                    }else{ // not event
                        if item.content?.count == 1{
                            let calendar = ReverseCalendarEconomicModel(
                                id: item.content?.first?.id ?? 0,
                                previous: item.content?.first?.previous,
                                consensus: item.content?.first?.consensus,
                                actual: item.content?.first?.actual,
                                star: item.content?.first?.star,
                                revised: item.content?.first?.revised,
                                translate: item.content?.first?.translate,
                                influence: item.content?.first?.influence,
                                economics_id: item.content?.first?.economics_id,
                                pub_time: item.pub_time,
                                country_flag: item.country_flag,
                                current_date: item.content?.first?.pub_time_tz,
                                events_translate: item.events_translate)
                            self.listCalendars.append(calendar)
                        }else{
                            guard let contents = item.content else {return}
                            for eachContent in contents{
                                let calendar = ReverseCalendarEconomicModel(
                                    id: eachContent.id,
                                    previous: eachContent.previous,
                                    consensus: eachContent.consensus,
                                    actual: eachContent.actual,
                                    star: eachContent.star,
                                    revised: eachContent.revised,
                                    translate: eachContent.translate,
                                    influence: eachContent.influence,
                                    economics_id: eachContent.economics_id,
                                    pub_time: item.pub_time,
                                    country_flag: item.country_flag,
                                    current_date: eachContent.pub_time_tz,
                                    events_translate: item.events_translate)
                                self.listCalendars.append(calendar)
                            }
                        }
                    }
                    
                }
                print(self.listCalendars)
                print(self.listCalendars.count)
                self.tableView.reloadData()
            }
        }
    }
    
    
}

extension EconomicCalendarNewsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDaysOfMonth.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EconomicCalendarCollectionViewCell", for: indexPath) as! EconomicCalendarCollectionViewCell
        cell.configCell(item: listDaysOfMonth[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        self.selectDate = listDaysOfMonth[indexPath.row]
        if isAll{
            self.callAPIToGetCalendar(important: 0, date: self.selectDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue))
        }else{
            self.callAPIToGetCalendar(important: 1, date: self.selectDate.dateToString(format: DateformatterType.YYYY_MM_DD.rawValue))
        }
        
    }
}
extension EconomicCalendarNewsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCalendars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        cell.configCell(item: listCalendars[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listCalendars[indexPath.row].events_translate != ""{
            print("Event")
        }else{
            if let cell = tableView.cellForRow(at: indexPath) as? CalendarTableViewCell{
                UIView.animate(withDuration: 0.3) {
                    cell.bottomView.isHidden = !cell.bottomView.isHidden
                    if cell.bottomView.isHidden == true{
                        cell.heightBottomView.constant = 0
                    }else{
                        cell.heightBottomView.constant = 35
                    }
                }
                tableView.beginUpdates()
                tableView.endUpdates()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
}
