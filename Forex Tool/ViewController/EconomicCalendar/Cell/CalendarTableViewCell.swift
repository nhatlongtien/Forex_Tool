//
//  CalendarTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 05/12/2021.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var heightBottomView: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!{
        didSet{
            bottomView.isHidden = true
            
        }
    }
    @IBOutlet weak var actualTitleLbl: UILabel!
    @IBOutlet weak var previousTitleLbl: UILabel!
    @IBOutlet weak var preditTitleLbl: UILabel!
    @IBOutlet weak var previousValueLbl: UILabel!
    @IBOutlet weak var preditValueLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var impactImg: UIImageView!
    @IBOutlet weak var actualValueLbl: UILabel!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var importantImg: UIImageView!
    @IBOutlet weak var importantView: CustomeBoderRadiusView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightBottomView.constant = 0
        previousTitleLbl.text = "Previous:".localized()
        preditTitleLbl.text = "Predict:".localized()
        actualTitleLbl.text = "Actual:".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configCell(item:ReverseCalendarEconomicModel){
        print(item.events_translate)
        if item.events_translate != ""{ //Su kien
            bottomView.isHidden = true
            heightBottomView.constant = 0
            importantView.isHidden = true
            contentLbl.text = item.events_translate
            contentLbl.textColor = .black
            //
        }else{ //khong phai su kien
            importantView.isHidden = false
            impactImg.isHidden = false
            contentLbl.text = item.translate
            if item.influence == 1{
                contentLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
                actualValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
                previousValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
                preditValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
                impactImg.image = UIImage(named: "bull_icon")
            }else if item.influence == 2{
                contentLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
                actualValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
                previousValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
                preditValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
                impactImg.image = UIImage(named: "bear_icon")
            }else if item.influence == 3{
                contentLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
                actualValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
                previousValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
                preditValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
                impactImg.image = UIImage(named: "neutral_icon")
            }
            
            if ((item.current_date?.formartDate(inputFormat: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue)))! > Date(){
                impactImg.isHidden = true
                importantView.backgroundColor = .lightGray
                contentLbl.textColor = .black
                actualValueLbl.textColor = .black
                previousValueLbl.textColor = .black
                preditValueLbl.textColor = .black
            }
        }
    
        
        postDateLbl.text = item.current_date?.formatDateWithInputTypeAndOutputType(inputFormat: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue, outputFormat: DateformatterType.HH_mm.rawValue)
        self.actualValueLbl.text = item.actual ?? "-"
        self.previousValueLbl.text = item.previous ?? "-"
        self.preditValueLbl.text = item.consensus ?? "-"
        let escapedString = item.country_flag?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.flagImg.kf.setImage(with: URL(string: escapedString!))
        switch item.star {
        case "1":
            self.importantImg.image = UIImage(named: "one_star")
        case "2":
            self.importantImg.image = UIImage(named: "two_star")
        case "3":
            self.importantImg.image = UIImage(named: "three_star")
        default:
            break
        }
    }
    
}
