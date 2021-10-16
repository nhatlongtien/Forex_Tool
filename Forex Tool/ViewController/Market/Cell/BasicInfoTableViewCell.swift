//
//  BasicInfoTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/10/2021.
//

import UIKit

class BasicInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
