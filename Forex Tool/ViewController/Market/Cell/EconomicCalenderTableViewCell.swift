//
//  EconomicCalenderTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/10/2021.
//

import UIKit

class EconomicCalenderTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var preditLbl: UILabel!
    @IBOutlet weak var importantImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:EconomicCalendarModel){
        currencyLbl.text = item.currency
        newsTitleLbl.text = item.title
        switch item.importance {
        case "0":
            self.importantImgView.image = UIImage(named: "one_star")
        case "1":
            self.importantImgView.image = UIImage(named: "two_star")
        case "2":
            self.importantImgView.image = UIImage(named: "three_star")
        default:
            break
        }
        let time = item.date?.formartDate(inputFormat: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue)
        let timeString = time?.dateToString(format: DateformatterType.MM_DD_HH_mm.rawValue)
        timeLbl.text = timeString
        preditLbl.text = "Actual: \(item.actual!) | Forcast: \(item.forecast!) | Previous: \(item.previous!)"
        
    }
}
