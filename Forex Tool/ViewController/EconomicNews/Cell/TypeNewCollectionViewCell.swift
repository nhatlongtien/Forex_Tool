//
//  TypeNewCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/09/2021.
//

import UIKit

class TypeNewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var greenView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(item:String){
        self.titleLbl.text = item
    }
    override var isSelected: Bool{
        didSet{
            if isSelected == true{
                titleLbl.font = UIFont(name: "Roboto-Bold", size: 16)
                greenView.isHidden = false
            }else{
                titleLbl.font = UIFont(name: "Roboto-Regular", size: 16)
                greenView.isHidden = true
            }
        }
    }
}
