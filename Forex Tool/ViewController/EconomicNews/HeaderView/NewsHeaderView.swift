//
//  NewsHeaderView.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/09/2021.
//

import UIKit
import Kingfisher
import Firebase
protocol NewsHeaderViewDelegate:class {
    func didTapContentView()
}
class NewsHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var publicDateLbl: UILabel!
    //
    weak var delegate:NewsHeaderViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        //fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        Bundle.main.loadNibNamed("NewsHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapContentView))
        contentView.addGestureRecognizer(tapGesture)
    }
    func configView(item:NewsItem){
        titleLbl.text = item.title
        if item.imageUrl == nil{
            imageView.image = UIImage(named: "defaultImage")
        }else{
            imageView.kf.setImage(with: URL(string: item.imageUrl!))
        }
        let nowTimestamp = Timestamp(date: Date())
        let publicTimestamp = Timestamp(date: item.pubdate!)
        let delta = nowTimestamp.seconds - publicTimestamp.seconds
        if delta <= 86400 {
            let hours = Int(delta/3600)
            let minutes = (Int(delta) - hours*60*60)/60
            if hours == 0 {
                self.publicDateLbl.text = "\(minutes) Phút trước"
            }else{
                self.publicDateLbl.text = "\(hours) Giờ trước"
            }
        }else{
            let publicDateStr = item.pubdate?.dateToString(format: DateformatterType.DD_MMMM.rawValue)
            self.publicDateLbl.text = publicDateStr
        }
    }
    @objc func handleDidTapContentView(){
        self.delegate?.didTapContentView()
    }
}
