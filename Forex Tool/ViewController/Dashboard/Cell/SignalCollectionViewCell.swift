//
//  SignalCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 16/12/2021.
//

import UIKit

class SignalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var chartImageView: UIImageView!
    @IBOutlet weak var titleSignalLbl: UILabel!
    @IBOutlet weak var contentSignalLbl: UILabel!
    @IBOutlet weak var pubDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(item:NotificationModel){
        titleSignalLbl.text = item.title?.uppercased()
        contentSignalLbl.text = item.body?.replacingOccurrences(of: "\\n", with: "\n")
        pubDateLbl.text = item.date?.formatDateWithInputTypeAndOutputType(inputFormat: DateformatterType.YYYY_MM_DD_T_HH_mm_ssZ.rawValue, outputFormat: DateformatterType.h_mm_a_DD_MMM_YYYY.rawValue)
        if item.urlMedia != nil && item.urlMedia != ""{
            chartImageView.kf.setImage(with: URL(string: (item.urlMedia)!))
        }else{
            chartImageView.image = UIImage(named: "default_chart")
        }
    }

}
