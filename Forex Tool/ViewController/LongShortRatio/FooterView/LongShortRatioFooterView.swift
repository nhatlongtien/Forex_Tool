//
//  LongShortRatioFooterView.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 19/09/2021.
//

import UIKit
import Charts
class LongShortRatioFooterView: UIView {

    @IBOutlet weak var longVolumeLbl: UILabel!
    @IBOutlet weak var shortVolumeLbl: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    var longShortItem: ExchangeLongShortRatioModel? = nil {
        didSet{
            guard let longRate = longShortItem?.longRate else {return}
            guard let shortRate = longShortItem?.shortRate else {return}
            self.setupPieChart(longRate: longRate.round(to: 1), shortRate: shortRate.round(to: 1))
            longVolumeLbl.text = longShortItem?.longVolUsd?.formaterCurrentPriceWithTwoFractionDigits()
            shortVolumeLbl.text = longShortItem?.shortVolUsd?.formaterCurrentPriceWithTwoFractionDigits()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        Bundle.main.loadNibNamed("LongShortRatioFooterView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
//        setupPieChart(longVolume: 60, shortVolume: 40)
    }
    func setupPieChart(longRate:Double, shortRate:Double){
        //
        pieChartView.centerText = longShortItem?.symbol
        let d = Description()
        d.text = "Description"
        d.font = UIFont(name: "Roboto-Regular", size: 13)!
        d.textColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.3882352941, alpha: 1)
        d.textAlign = .right
        pieChartView.chartDescription = d
        //pieChartView.entryLabelFont = UIFont(name: "Roboto-Regular", size: 2)!
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.3
        pieChartView.showsLargeContentViewer = true
        //
        var entries:[PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: longRate, label: "Buy"))
        entries.append(PieChartDataEntry(value: shortRate, label: "Sell"))
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
}

