//
//  CommentTableViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 13/12/2021.
//

import UIKit
import Kingfisher
class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLbl: UILabel! 
    @IBOutlet weak var pubDateLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var commentImgView: UIImageView!
    @IBOutlet weak var heightCommentImg: NSLayoutConstraint!
    @IBOutlet weak var avatarImg: UIImageView!
    let dashboardVM = DashboardViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.showAnimatedGradientSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(item:CommentModel){
        contentLbl.text = item.messTxt
        contentLbl.hideSkeleton()
        pubDateLbl.text = item.pubdate
        pubDateLbl.hideSkeleton()
        if item.mediaUrl != nil && item.mediaUrl != ""{
            commentImgView.isHidden = false
            heightCommentImg.constant = 125
            commentImgView.kf.setImage(with: URL(string: item.mediaUrl!))
            self.commentImgView.hideSkeleton()
        }else{
            heightCommentImg.constant = 0
            commentImgView.isHidden = true
            self.commentImgView.hideSkeleton()
        }
        getUserAndUpdateUI(userID: item.userID!)
    }
    func getUserAndUpdateUI(userID:String){
        dashboardVM.getUserInfoByUserID(userID: userID) { (success, userInfo) in
            if success{
                //
                self.nameLbl.text = userInfo?.fullName?.capitalized
                let urlImage = userInfo?.avatarImg
                if urlImage != nil && urlImage != ""{
                    self.avatarImg.kf.setImage(with: URL(string: urlImage!))
                    self.avatarImg.hideSkeleton()
                }else{
                    self.avatarImg.image = UIImage(named: "userIcon")
                    self.avatarImg.hideSkeleton()
                }
            }
        }
    }
    
}
