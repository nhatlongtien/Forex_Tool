//
//  FeedNewsTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 26/11/2021.
//

import UIKit
import Kingfisher
class FeedNewsCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var impactImg: UIImageView!
    @IBOutlet weak var actualValueLbl: UILabel!
    @IBOutlet weak var flagImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:HotNews247Model){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedContent = NSAttributedString(string: item.content ?? "", attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        
        self.contentLbl.attributedText = attributedContent
        self.postDateLbl.text = item.postTime?.dateToString(format: DateformatterType.HH_mm_ss.rawValue)
        if item.impactNews == "good_news"{
            contentLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
            actualValueLbl.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
            impactImg.image = UIImage(named: "bull_icon")
        }else if item.impactNews == "bad_news"{
            contentLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
            actualValueLbl.textColor = UIColor(red: 242/255, green: 69/255, blue: 61/255, alpha: 1)
            impactImg.image = UIImage(named: "bear_icon")
        }else if item.impactNews == "neutral_news"{
            contentLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
            actualValueLbl.textColor = UIColor(red: 249/255, green: 204/255, blue: 73/255, alpha: 1)
            impactImg.image = UIImage(named: "neutral_icon")
        }
        self.actualValueLbl.text = item.value
        let escapedString = item.flagImageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.flagImg.kf.setImage(with: URL(string: escapedString!))
    }
    
}
