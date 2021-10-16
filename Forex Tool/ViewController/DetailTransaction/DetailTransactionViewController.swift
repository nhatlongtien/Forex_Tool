//
//  DetailTransactionViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 03/10/2021.
//

import UIKit

class DetailTransactionViewController: BaseViewController {
    @IBOutlet weak var pairCurrencyTitle: UILabel!
    @IBOutlet weak var typeTransactionTitle: UILabel!
    @IBOutlet weak var entryPriceTitle: UILabel!
    @IBOutlet weak var stopLossPriceTitle: UILabel!
    @IBOutlet weak var takeProfitPriceTitle: UILabel!
    @IBOutlet weak var lotSizeTitle: UILabel!
    @IBOutlet weak var pipsLossTitle: UILabel!
    @IBOutlet weak var pipsGianTitle: UILabel!
    @IBOutlet weak var amountRiskTitle: UILabel!
    @IBOutlet weak var amountGainTitle: UILabel!
    @IBOutlet weak var riskRewardRatioTitle: UILabel!
    @IBOutlet weak var riskRateTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var pairCurrencyLbl: UILabel!
    @IBOutlet weak var typeTransactionLbl: UILabel!
    @IBOutlet weak var entryPriceLbl: UILabel!
    @IBOutlet weak var SLPriceLbl: UILabel!
    @IBOutlet weak var TPPriceLbl: UILabel!
    @IBOutlet weak var lotSizeLbl: UILabel!
    @IBOutlet weak var pipsLossLbl: UILabel!
    @IBOutlet weak var pipsGainLbl: UILabel!
    @IBOutlet weak var amountRiskLbl: UILabel!
    @IBOutlet weak var amountGainLbl: UILabel!
    @IBOutlet weak var riskRewardRatioLbl: UILabel!
    @IBOutlet weak var riskRateLbl: UILabel!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var heightReasonView: NSLayoutConstraint!
    @IBOutlet weak var chartImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    //
    var selectedTransactionItem:TransactionModel?
    override func viewDidLoad() {
        //
        setupUI()
        //
        super.viewDidLoad()
        reasonView.isHidden = true
        heightReasonView.constant = 0
        descriptionTextView.isUserInteractionEnabled = false
        //
        guard let transactionItem = selectedTransactionItem else {return}
        showDataForUI(transactionItem: transactionItem)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Detail Transaction".localized()
    }
    //MARK: Helper Method
    func setupUI(){
        pairCurrencyTitle.text = "Pair Currency:".localized()
        typeTransactionTitle.text = "Type Transaction:".localized()
        entryPriceTitle.text = "Entry Price:".localized()
        stopLossPriceTitle.text = "Stop Loss Price:".localized()
        takeProfitPriceTitle.text = "Take Profit Price:".localized()
        lotSizeTitle.text = "Lot Size (Volume):".localized()
        pipsLossTitle.text = "Pips Loss:".localized()
        pipsGianTitle.text = "Pips Gain:".localized()
        riskRewardRatioTitle.text = "Risk Reward Ratio:".localized()
        riskRateTitle.text = "Risk Rate:".localized()
        descriptionTitle.text = "Description:".localized()
        dateTitle.text = "Date:".localized()
    }
    func showDataForUI(transactionItem:TransactionModel){
        
        
        if transactionItem.detail?.type == TypeTransaction.Buy.rawValue || transactionItem.detail?.type == TypeTransaction.BuyLimit.rawValue{
            imageView.image = UIImage(named: "increaseMarketIcon")
        }else if transactionItem.detail?.type == TypeTransaction.Sell.rawValue || transactionItem.detail?.type == TypeTransaction.SellLimit.rawValue{
            imageView.image = UIImage(named: "decreaseMarketIcon")
        }
        //
        statusLbl.text = "Status:".localized() + " \(transactionItem.status!)"
        pairCurrencyLbl.text = transactionItem.pairCurrency
        typeTransactionLbl.text = transactionItem.detail?.type
        if let lotSize = transactionItem.detail?.lotSize{
            lotSizeLbl.text = lotSize.formaterCurrentPriceWithTwoFractionDigits() + " lots"
        }
        if let pipsLoss = transactionItem.detail?.pipsLoss{
            pipsLossLbl.text = pipsLoss.formaterValueOfPips() + " pips"
        }
        if let pipsGain = transactionItem.detail?.pipsProfit{
            pipsGainLbl.text = pipsGain.formaterValueOfPips() + " pips"
        }
        if let amountRisk = transactionItem.detail?.lossMoney{
            amountRiskLbl.text = amountRisk.formaterCurrentPriceWithTwoFractionDigits() + " $"
        }
        if let amountGain = transactionItem.detail?.rewardMoney{
            amountGainLbl.text = amountGain.formaterCurrentPriceWithTwoFractionDigits() + " $"
        }
        if let riskRate = transactionItem.ristRate{
            riskRateLbl.text = riskRate.formaterCurrentPriceWithTwoFractionDigits() + " %"
        }
        if let riskRewardRatio = transactionItem.detail?.RRRate{
            riskRewardRatioLbl.text = riskRewardRatio
        }
        dateLbl.text = transactionItem.dateCreate
        
        switch transactionItem.groupCurrency {
        case CurrencyGroup.USD_XXX.rawValue, CurrencyGroup.XXX_USD.rawValue, CurrencyGroup.XXX_XXX.rawValue:
            if let entryPrice = transactionItem.detail?.entryPoint{
                entryPriceLbl.text = entryPrice.formaterCurrentPriceWithFiveFractionDigits()
            }
            if let SLPrice = transactionItem.detail?.stopLossPoint{
                SLPriceLbl.text = SLPrice.formaterCurrentPriceWithFiveFractionDigits()
            }
            if let TPPrice = transactionItem.detail?.takeProfitPoint{
                TPPriceLbl.text = TPPrice.formaterCurrentPriceWithFiveFractionDigits()
            }
        case CurrencyGroup.XXX_JPY.rawValue, CurrencyGroup.XAU_USD.rawValue:
            if let entryPrice = transactionItem.detail?.entryPoint{
                entryPriceLbl.text = entryPrice.formaterCurrentPriceWith3FractionDigits()
            }
            if let SLPrice = transactionItem.detail?.stopLossPoint{
                SLPriceLbl.text = SLPrice.formaterCurrentPriceWith3FractionDigits()
            }
            if let TPPrice = transactionItem.detail?.takeProfitPoint{
                TPPriceLbl.text = TPPrice.formaterCurrentPriceWith3FractionDigits()
            }
        case CurrencyGroup.BTC_USD.rawValue:
            if let entryPrice = transactionItem.detail?.entryPoint{
                entryPriceLbl.text = entryPrice.formaterCurrentPriceWithTwoFractionDigits()
            }
            if let SLPrice = transactionItem.detail?.stopLossPoint{
                SLPriceLbl.text = SLPrice.formaterCurrentPriceWithTwoFractionDigits()
            }
            if let TPPrice = transactionItem.detail?.takeProfitPoint{
                TPPriceLbl.text = TPPrice.formaterCurrentPriceWithTwoFractionDigits()
            }
        default:
            break
        }
        
        if transactionItem.detail?.hasReason == 1{ //Have reason view
            reasonView.isHidden = false
            heightReasonView.constant = 300
            if transactionItem.detail?.chartImage != nil && transactionItem.detail?.chartImage != ""{
                self.chartImageView.kf.setImage(with: URL(string: (transactionItem.detail?.chartImage)!) )
            }
            descriptionTextView.text = transactionItem.detail?.reasonDescription
        }else{
            reasonView.isHidden = true
            heightReasonView.constant = 0
        }
    }
}
