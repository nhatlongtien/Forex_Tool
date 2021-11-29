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
    
    @IBOutlet weak var sourceFromLogo: UIImageView!
    
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
            let escapedString = item.imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imageNewView?.kf.setImage(with: URL(string: escapedString!))
        }
        
        let publicDateStr = item.pubdate?.dateToString(format: DateformatterType.DD_MM_YYYY.rawValue)
        self.puplicDateLbl.text = publicDateStr
        switch item.author {
        case SourceFrom.tapchibitcoin.rawValue:
            sourceFromLogo.image = UIImage(named: "TapChiBitcoin")
        case SourceFrom.investing.rawValue:
            sourceFromLogo.image = UIImage(named: "investingLogo")
        case SourceFrom.invest138.rawValue:
            sourceFromLogo.image = UIImage(named: "invest318_icon")
        case SourceFrom.blogtienao.rawValue:
            sourceFromLogo.image = UIImage(named: "blogtienao_icon")
        case SourceFrom.vic.rawValue:
            sourceFromLogo.image = UIImage(named: "vic_icon")
        case SourceFrom.forex.rawValue:
            sourceFromLogo.image = UIImage(named: "forex_icon")
        case SourceFrom.finnews24.rawValue:
            sourceFromLogo.image = UIImage(named: "finnews_icon")
        default:
            break
        }
    }
    
}
