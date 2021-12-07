//
//  FeedNewsTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 26/11/2021.
//

import UIKit
import Kingfisher
class FeedNewsCalendarTableViewCell: UITableViewCell {

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
    override func awakeFromNib() {
        super.awakeFromNib()
        previousTitleLbl.text = "Previous:".localized()
        preditTitleLbl.text = "Predict:".localized()
        actualTitleLbl.text = "Actual:".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:Feed247NewsModel){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedContent = NSAttributedString(string: item.attr_json.vi ?? "", attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        
        self.contentLbl.attributedText = attributedContent
        self.postDateLbl.text = item.time
        if item.influence == "1"{
            contentLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
            actualValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
            previousValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
            preditValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
            impactImg.image = UIImage(named: "bull_icon")
        }else if item.influence == "2"{
            contentLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
            actualValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
            previousValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
            preditValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
            impactImg.image = UIImage(named: "bear_icon")
        }else{
            contentLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
            actualValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
            previousValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
            preditValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
            impactImg.image = UIImage(named: "neutral_icon")
        }
        self.actualValueLbl.text = item.actual ?? "-"
        self.previousValueLbl.text = item.previous ?? "-"
        self.preditValueLbl.text = item.consensus ?? "-"
        let escapedString = item.country?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
