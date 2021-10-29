//
//  NotificationTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/10/2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var checkImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkImgView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:NotificationModel){
        self.titleLbl.text = item.title
        self.bodyLbl.text = item.body?.replacingOccurrences(of: "\\n", with: "\n")
        self.hourLbl.text = item.date?.hourFormatterForNotifi()
        
    }
    
}
