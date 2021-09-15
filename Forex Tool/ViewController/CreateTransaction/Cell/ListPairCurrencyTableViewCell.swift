//
//  ListPairCurrencyTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/07/2021.
//

import UIKit

class ListPairCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMarkImg: UIImageView!
    @IBOutlet weak var namePairCurrencyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(pairCurrency:PairCurrencyModel, currentPairCurrency:String){
        namePairCurrencyLbl.text = pairCurrency.name
        if pairCurrency.name == currentPairCurrency{
            checkMarkImg.isHidden = false
        }else{
            checkMarkImg.isHidden = true
        }
    }
    
}
