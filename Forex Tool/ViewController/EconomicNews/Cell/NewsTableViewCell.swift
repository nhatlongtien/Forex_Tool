//
//  NewsTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 16/09/2021.
//

import UIKit
import Kingfisher
import Firebase
class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNewView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var puplicDateLbl: UILabel!
    
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
        if item.imageUrl == nil{
            imageNewView?.image = UIImage(named: "defaultImage")
        }else{
            imageNewView?.kf.setImage(with: URL(string: item.imageUrl!))
        }
        let nowTimestamp = Timestamp(date: Date())
        let publicTimestamp = Timestamp(date: item.pubdate!)
        let delta = nowTimestamp.seconds - publicTimestamp.seconds
        if delta <= 86400 {
            let hours = Int(delta/3600)
            let minutes = (Int(delta) - hours*60*60)/60
            if hours == 0 {
                self.puplicDateLbl.text = "\(minutes) Phút trước"
            }else{
                self.puplicDateLbl.text = "\(hours) Giờ trước"
            }
        }else{
            let publicDateStr = item.pubdate?.dateToString(format: DateformatterType.DD_MMMM.rawValue)
            self.puplicDateLbl.text = publicDateStr
        }
        
        
    }
    
}
