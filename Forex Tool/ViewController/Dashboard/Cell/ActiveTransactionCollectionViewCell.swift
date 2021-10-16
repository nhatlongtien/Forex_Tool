//
//  ActiveTransactionCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 11/07/2021.
//

import UIKit

class ActiveTransactionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backGroundView: CustomeBoderRadiusView!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var pairCurrencyLbl: UILabel!
    @IBOutlet weak var lotSizeLbl: UILabel!
    @IBOutlet weak var entryLbl: UILabel!
    @IBOutlet weak var stopLossLbl: UILabel!
    @IBOutlet weak var takeProfitLbl: UILabel!
    @IBOutlet weak var rewardLbl: UILabel!
    @IBOutlet weak var lossLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rrRateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.layer.cornerRadius = 10
        backgroundImageView.clipsToBounds = true
    }
    func configCell(transaction:TransactionModel){
        self.pairCurrencyLbl.text = transaction.pairCurrency! + " " + "(\(transaction.detail?.type ?? ""))"
        self.rewardLbl.text = "Reward:".localized() + " \(transaction.detail?.rewardMoney?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")$"
        self.lossLbl.text = "Loss:".localized() + " \(transaction.detail?.lossMoney?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")$"
        self.rrRateLbl.text = transaction.detail?.RRRate
        self.lotSizeLbl.text = "\(transaction.detail?.lotSize?.formaterCurrentPriceWithTwoFractionDigits() ?? "0") (\(transaction.ristRate ?? 0)%)"
        self.dateLbl.text = transaction.dateCreate?.formartDate(inputFormat: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue).dateToString(format: DateformatterType.DD_MM_YYYY.rawValue)
        switch transaction.groupCurrency {
        case CurrencyGroup.XAU_USD.rawValue, CurrencyGroup.XXX_JPY.rawValue:
            self.entryLbl.text = "Entry: \(transaction.detail?.entryPoint?.formaterCurrentPriceWith3FractionDigits() ?? "0")" 
            self.stopLossLbl.text = "SL: \(transaction.detail?.stopLossPoint?.formaterCurrentPriceWith3FractionDigits() ?? "0")"
            self.takeProfitLbl.text = "TP: \(transaction.detail?.takeProfitPoint?.formaterCurrentPriceWith3FractionDigits() ?? "0")"
        case CurrencyGroup.BTC_USD.rawValue:
            self.entryLbl.text = "Entry: \(transaction.detail?.entryPoint?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")"
            self.stopLossLbl.text = "SL: \(transaction.detail?.stopLossPoint?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")"
            self.takeProfitLbl.text = "TP: \(transaction.detail?.takeProfitPoint?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")"
        default:
            self.entryLbl.text = "Entry: \(transaction.detail?.entryPoint?.formaterCurrentPriceWithFiveFractionDigits() ?? "0")"
            self.stopLossLbl.text = "SL: \(transaction.detail?.stopLossPoint?.formaterCurrentPriceWithFiveFractionDigits() ?? "0")"
            self.takeProfitLbl.text = "TP: \(transaction.detail?.takeProfitPoint?.formaterCurrentPriceWithFiveFractionDigits() ?? "0")"
        }
    }
}
