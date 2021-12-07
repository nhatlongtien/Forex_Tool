//
//  EconomicCalendarCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 05/12/2021.
//

import UIKit
import SwiftUI

class EconomicCalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ELbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var containView: CustomeBoderRadiusView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                containView.backgroundColor = .systemBlue
                ELbl.textColor = .white
                dateLbl.textColor = .white
            }else{
                containView.backgroundColor = .white
                ELbl.textColor = .systemBlue
                dateLbl.textColor = UIColor(red: 16/255, green: 0/255, blue: 54/255, alpha: 1)
            }
        }
    }
    
    
    
    func configCell(item:Date){
        self.ELbl.text = item.dateToString(format: DateformatterType.E.rawValue)
        self.dateLbl.text = item.dateToString(format: DateformatterType.dd_MM.rawValue)
    }
}
