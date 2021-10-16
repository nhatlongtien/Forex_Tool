//
//  AnalysisTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 10/10/2021.
//

import UIKit
import Firebase
class AnalysisTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:NewsItem){
        titleLbl.text = item.title
        authorLbl.text = item.author?.capitalized
        let nowTimestamp = Timestamp(date: Date())
        let publicTimestamp = Timestamp(date: item.pubdate!)
        let delta = nowTimestamp.seconds - publicTimestamp.seconds
        if delta <= 86400 {
            let hours = Int(delta/3600)
            let minutes = (Int(delta) - hours*60*60)/60
            if hours == 0 {
                self.timeLbl.text = "\(minutes) Phút trước"
            }else{
                self.timeLbl.text = "\(hours) Giờ trước"
            }
        }else{
            let publicDateStr = item.pubdate?.dateToString(format: DateformatterType.DD_MMMM.rawValue)
            self.timeLbl.text = publicDateStr
        }
    }
    
}
