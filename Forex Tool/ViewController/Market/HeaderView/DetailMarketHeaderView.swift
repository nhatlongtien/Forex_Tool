//
//  DetailMarketHeaderView.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 06/10/2021.
//

import UIKit
protocol DetailMarketHeaderViewDelegate:class{
    func chooseDurationTimeDidTap()
}
class DetailMarketHeaderView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var durationLbl: UILabel!
    
    weak var deleate:DetailMarketHeaderViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func chooseDurationButtonWasPressed(_ sender: Any) {
        self.deleate?.chooseDurationTimeDidTap()
    }
    //
    func setupView(){
        Bundle.main.loadNibNamed("DetailMarketHeaderView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
