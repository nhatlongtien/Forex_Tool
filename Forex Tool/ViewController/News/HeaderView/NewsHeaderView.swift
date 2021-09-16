//
//  NewsHeaderView.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/09/2021.
//

import UIKit

class NewsHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var publicDateLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        Bundle.main.loadNibNamed("NewsHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
    }
}
