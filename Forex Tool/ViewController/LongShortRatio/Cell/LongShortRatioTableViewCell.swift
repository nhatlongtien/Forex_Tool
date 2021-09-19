//
//  LongShortRatioTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/09/2021.
//

import UIKit
import MultiProgressView
class LongShortRatioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var platformImg: UIImageView!
    @IBOutlet weak var platformNameLbl: UILabel!
    @IBOutlet weak var multiProgressView: MultiProgressView!
    //
    var selectedItem:List?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupUI(){
        multiProgressView.dataSource = self
        multiProgressView.delegate = self
        multiProgressView.lineCap = .round
        multiProgressView.cornerRadius = 8
        multiProgressView.clipsToBounds = true
    }
    func configCell(item:List){
        self.selectedItem = item
        self.multiProgressView.reloadData()
        let longRate = Float(item.longRate!) / 100
        let shortRate = Float(item.shortRate!) / 100
        animateSetProgress(multiProgressView, firstProgress: longRate, secondProgress: shortRate)
        //
        self.platformNameLbl.text = item.exchangeName
        if let url = URL(string: item.exchangeLogo!){
            self.platformImg.kf.setImage(with: url)
        }
        
    }
    //MARK: Helper Method
    func animateSetProgress(_ progressView: MultiProgressView,
                                    firstProgress: Float,
                                    secondProgress: Float) {
//        UIView.animate(withDuration: 0.05,
//                       delay: 0,
//                       options: .curveEaseInOut,
//                       animations: { progressView.setProgress(section: 0, to: firstProgress) },
//                       completion: { _ in
//                        UIView.animate(withDuration: 0.25,
//                                       delay: 0,
//                                       options: .curveEaseInOut,
//                                       animations: { progressView.setProgress(section: 1, to: secondProgress) },
//                                       completion: nil)
//                       })
        
        progressView.setProgress(section: 0, to: firstProgress)
        progressView.setProgress(section: 1, to: secondProgress)
    }
}
//MARK:
extension LongShortRatioTableViewCell:MultiProgressViewDelegate, MultiProgressViewDataSource{
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 2
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        switch section {
        case 0:
            sectionView.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.6431372549, blue: 0.6235294118, alpha: 1)
            sectionView.titleLabel.text = String(format: "%.2f", selectedItem?.longRate ?? 0) + "%"
            sectionView.titleLabel.font = UIFont(name: "Roboto-Regular", size: 12)
            sectionView.titleLabel.textColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.3882352941, alpha: 1)
        case 1:
            sectionView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            sectionView.titleLabel.text = String(format: "%.2f", selectedItem?.shortRate ?? 0) + "%"
            sectionView.titleLabel.font = UIFont(name: "Roboto-Regular", size: 12)
            sectionView.titleLabel.textColor = #colorLiteral(red: 0.06274509804, green: 0, blue: 0.3882352941, alpha: 1)
        default:
            break
        }
        return sectionView
    }
    
    
}
