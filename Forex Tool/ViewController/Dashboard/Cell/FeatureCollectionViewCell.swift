//
//  FeatureCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 27/11/2021.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconButton: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(item:FeatureModel){
        iconButton.image = UIImage(named: item.nameIcon)
        titleLbl.text = item.title
        
    }
}
