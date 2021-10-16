//
//  HomeMarketCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 04/10/2021.
//

import UIKit

class HomeMarketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var marketImageView: UIImageView!
    @IBOutlet weak var changeView: CustomeBoderRadiusView!
    @IBOutlet weak var changePersentLbl: UILabel!
    @IBOutlet weak var nameCurrencyLbl: UILabel!
    @IBOutlet weak var currenctPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailTitle.text = "Go to Detail".localized()
    }
    func configCell(item:PricePairCurrencyModel){
        let isContainPlus = item.changeInPercentage?.contains("+")
        
        if isContainPlus == true{//bull market
            marketImageView.image = UIImage(named: "bull_market")
            changeView.backgroundColor = .systemGreen
        }else{
            marketImageView.image = UIImage(named: "bear_market")
            changeView.backgroundColor = .systemRed
        }
        changePersentLbl.text = item.changeInPercentage
        nameCurrencyLbl.text = item.symbol?.uppercased()
        currenctPrice.text = item.currentPrice
    }

}
