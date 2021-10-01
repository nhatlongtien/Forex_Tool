//
//  LongShortRatioViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/09/2021.
//

import UIKit
import PKHUD
import DropDown
class LongShortRatioViewController: BaseViewController {

    @IBOutlet weak var symbolView: UIView!
    @IBOutlet weak var periodView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var cryptoNameLbl: UILabel!
    //MARK: Drop Down
    let symbolDropdown = DropDown()
    let periodDropdown = DropDown()
    //
    let longShortRatioVM = LongShortRatioViewModel()
    let listCrypto = Constant.defaults.array(forKey: Constant.CRYPTO_KEY) as! [String]
    let listPeriod = Constant.defaults.array(forKey: Constant.PERIOD_TIME_KEY) as! [String]
    var crytoName:String = "BTC"
    var period:String = "3"
    //
    var timer:Timer?
    //
    let footerView = LongShortRatioFooterView()
    //
    var ratioItem:ExchangeLongShortRatioModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //self.viewModleCallBack()
        //
        let nibCell = UINib(nibName: "LongShortRatioTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "LongShortRatioTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        //
        DropDown.setupDefaultAppearance()
        setupDropDowns()
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Long Short Ratio"
        //
        
        self.getListLongShortRatioRealtime()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.timer?.invalidate()
    }
    //MARK: UI Event
    @IBAction func listSymbolButtonWasPressed(_ sender: Any) {
        symbolDropdown.show()
    }
    @IBAction func listPeriodButtonWasPressed(_ sender: Any) {
        periodDropdown.show()
    }
    
    //MARK: Helper Method
    func viewModleCallBack(){
        longShortRatioVM.beforeApiCall = {
            self.view.isUserInteractionEnabled = false
            HUD.show(.systemActivity)
        }
        longShortRatioVM.afterApiCall = {
            self.view.isUserInteractionEnabled = true
            HUD.hide()
        }
    }
    func setupDropDowns(){
        setupSymbolDropdown()
        setupPeriodDropdown()
    }
    func setupSymbolDropdown(){
        symbolDropdown.anchorView = symbolView
        symbolDropdown.dataSource = listCrypto.sorted()
        symbolDropdown.selectionAction = {[weak self] (index, item) in
            self?.crytoName = item
            self?.cryptoNameLbl.text = item
            self?.timer?.invalidate()
            self?.getListLongShortRatioRealtime()
            print(item)
        }
    }
    func setupPeriodDropdown(){
        periodDropdown.anchorView = periodView
        periodDropdown.dataSource = listPeriod
        periodDropdown.selectionAction = {[weak self] (index, item) in
            switch item {
            case "5M":
                self?.period = "3"
            case "15M":
                self?.period = "10"
            case "30M":
                self?.period = "11"
            case "1H":
                self?.period = "2"
            case "4H":
                self?.period = "1"
            case "12H":
                self?.period = "4"
            case "24H":
                self?.period = "5"
            default:
                break
            }
            self?.periodLbl.text = item
            self?.timer?.invalidate()
            self?.getListLongShortRatioRealtime()
            print(item)
        }
    }
    func getListLongShortRatioRealtime(){
        self.getListLongShortRatio()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [self] (timer) in
            self.getListLongShortRatio()
        })
    }
    func getListLongShortRatio(){
        longShortRatioVM.getLongShortRatio(time: period, symbol: crytoName) { [self] (success, item) in
            if success{
                print(item?.list?.count)
                let lists = item?.list
                for eachItem in lists!{
                    print(eachItem.exchangeName)
                }
                guard let ratioItem = item else {return}
                self.ratioItem = ratioItem
                self.footerView.longShortItem = self.ratioItem
                tableView.reloadData()
            }
        }
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension LongShortRatioViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = ratioItem?.list {
            return list.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LongShortRatioTableViewCell", for: indexPath) as! LongShortRatioTableViewCell
        
        if let listItem = ratioItem?.list {
            cell.configCell(item: listItem[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9524082541, green: 0.9641407132, blue: 1, alpha: 1)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
