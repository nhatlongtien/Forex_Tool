//
//  PhoToLibraryCollectionViewCell.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 21/12/2021.
//

import UIKit

class PhoToLibraryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var takePhotoView: UIView!
    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var selectImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool{
        didSet{
            if isSelected == true{
                selectImgView.image = UIImage(named: "blueCircle")
            }else{
                selectImgView.image = UIImage(named: "unselect_icon")
            }
        }
    }

}
