//
//  FeedNewsTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 26/11/2021.
//

import UIKit
import SkeletonView
class FeedNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.contentLbl.isSkeletonable = true
        self.postDateLbl.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:Feed247NewsModel){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedContent = NSAttributedString(string: item.translate ?? "", attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        
        self.contentLbl.attributedText = attributedContent
        self.postDateLbl.text = item.time
        self.hideSkeleton()
    }
    
}
