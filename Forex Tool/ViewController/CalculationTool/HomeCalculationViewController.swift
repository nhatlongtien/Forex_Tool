//
//  HomeCalculationViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 28/09/2021.
//

import UIKit

class HomeCalculationViewController: BaseViewController {

    @IBOutlet weak var stopLossAndTakeProfitTitle: UILabel!
    @IBOutlet weak var positionSizeAndRiskTitle: UILabel!
    @IBOutlet weak var pipsValueTitle: UILabel!
    var isFromTabbar:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if isFromTabbar == false{
            self.navigationController?.navigationBar.isHidden = false
            self.title = "Calculator".localized()
        }
    }


    @IBAction func stopLossAndTakeProfitButtonWasPressed(_ sender: Any) {
        let targetVC = ProfitCalculatorViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func positionSizeAndRiskButtonWasPressed(_ sender: Any) {
        let targetVC = PositionSizeAndRiskCalculatorViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func pipValueButtonWasPressed(_ sender: Any) {
        let targetVC = PipValueViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    //MARK: Helper Method
    func setupUI(){
        pipsValueTitle.text = "Pip Value".localized()
        positionSizeAndRiskTitle.text = "Position Size & Risk".localized()
        stopLossAndTakeProfitTitle.text = "Stop Loss & Rake Profit".localized()
    }
}

