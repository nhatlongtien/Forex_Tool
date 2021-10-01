//
//  ManagerTransactionTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/07/2021.
//

import UIKit
protocol ManagerTransactionTableViewCellDelegate:class {
    func deleteTransactionButtonDidTap(transaction:TransactionModel)
    func editTransactionButtonDitTap(transaction:TransactionModel)
    func createTransactionButtonDidTap()
}
class ManagerTransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var emptyTransactionView: CustomeBoderRadiusView!
    @IBOutlet weak var containView: CustomeBoderRadiusView!
    @IBOutlet weak var imageTransaction: UIImageView!
    @IBOutlet weak var statusTransactionCircleView: CustomeBoderRadiusView!
    @IBOutlet weak var pairCurrencyLbl: UILabel!
    @IBOutlet weak var lotSizeLbl: UILabel!
    @IBOutlet weak var entryLbl: UILabel!
    @IBOutlet weak var stopLossLbl: UILabel!
    @IBOutlet weak var takeProfitLbl: UILabel!
    @IBOutlet weak var rewardLbl: UILabel!
    @IBOutlet weak var lossLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rrRateLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    //
    weak var delegate:ManagerTransactionTableViewCellDelegate?
    var selectedTransaction:TransactionModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(transaction:TransactionModel){
        self.selectedTransaction = transaction
        //
        self.pairCurrencyLbl.text = transaction.pairCurrency! + " " + "(\(transaction.detail?.type ?? ""))"
        self.rewardLbl.text = "Reward: " + "+\(transaction.detail?.rewardMoney?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")$"
        self.lossLbl.text = "Loss " + "-\(transaction.detail?.lossMoney?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")$"
        self.rrRateLbl.text = transaction.detail?.RRRate
        self.lotSizeLbl.text = "\(transaction.detail?.lotSize?.formaterCurrentPriceWithTwoFractionDigits() ?? "0") (\(transaction.ristRate ?? 0)%)"
        
        //
        switch transaction.detail?.result?.uppercased() {
        case ResultTransaction.Loss.rawValue.uppercased():
            self.resultLbl.textColor = .systemRed
        case ResultTransaction.Win.rawValue.uppercased():
            self.resultLbl.textColor = .systemGreen
        case ResultTransaction.Unknow.rawValue.uppercased():
            self.resultLbl.textColor = .systemPurple
        default:
            break
        }
        self.resultLbl.text = transaction.detail?.result?.uppercased()
        //
        self.dateLbl.text = transaction.dateCreate?.formartDate(inputFormat: DateformatterType.YYYY_MM_DD_HHMMSS.rawValue).dateToString(format: DateformatterType.DD_MM_YYYY.rawValue)
        switch transaction.groupCurrency {
        case CurrencyGroup.XAU_USD.rawValue, CurrencyGroup.XXX_JPY.rawValue:
            self.entryLbl.text = "Entry: \(transaction.detail?.entryPoint?.formaterCurrentPriceWith3FractionDigits() ?? "0")"
            self.stopLossLbl.text = "Stop Loss: \(transaction.detail?.stopLossPoint?.formaterCurrentPriceWith3FractionDigits() ?? "0")"
            self.takeProfitLbl.text = "Take Profit: \(transaction.detail?.takeProfitPoint?.formaterCurrentPriceWith3FractionDigits() ?? "0")"
        case CurrencyGroup.BTC_USD.rawValue:
            self.entryLbl.text = "Entry: \(transaction.detail?.entryPoint?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")"
            self.stopLossLbl.text = "Stop Loss: \(transaction.detail?.stopLossPoint?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")"
            self.takeProfitLbl.text = "Take Profit: \(transaction.detail?.takeProfitPoint?.formaterCurrentPriceWithTwoFractionDigits() ?? "0")"
        default:
            self.entryLbl.text = "Entry: \(transaction.detail?.entryPoint?.formaterCurrentPriceWithFiveFractionDigits() ?? "0")"
            self.stopLossLbl.text = "Stop Loss: \(transaction.detail?.stopLossPoint?.formaterCurrentPriceWithFiveFractionDigits() ?? "0")"
            self.takeProfitLbl.text = "Take Profit: \(transaction.detail?.takeProfitPoint?.formaterCurrentPriceWithFiveFractionDigits() ?? "0")"
        }
        //
        statusLbl.text = transaction.status
        //
        switch transaction.detail?.type {
        case TypeTransaction.Buy.rawValue, TypeTransaction.BuyLimit.rawValue:
            self.imageTransaction.image = UIImage(named: "increaseMarketIcon")
        case TypeTransaction.Sell.rawValue, TypeTransaction.SellLimit.rawValue:
            self.imageTransaction.image = UIImage(named: "decreaseMarketIcon")
        default:
            break
        }
    }
    @IBAction func editButtonWasPressed(_ sender: Any) {
        self.delegate?.editTransactionButtonDitTap(transaction: selectedTransaction!)
    }
    
    @IBAction func deleteButtonWasPressed(_ sender: Any) {
        self.delegate?.deleteTransactionButtonDidTap(transaction: selectedTransaction!)
    }
    @IBAction func createTransactionWasPressed(_ sender: Any) {
        self.delegate?.createTransactionButtonDidTap()
    }
}
