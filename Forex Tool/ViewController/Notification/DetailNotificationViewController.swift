//
//  DetailNotificationViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 20/10/2021.
//

import UIKit
import Kingfisher
import Lightbox
class DetailNotificationViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var publicDateLbl: UILabel!
    @IBOutlet weak var titleTlb: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    var notificationItem:NotificationModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTlb.text = notificationItem?.title?.uppercased()
        contentLbl.text = notificationItem?.body
        publicDateLbl.text = notificationItem?.date?.formatDateWithInputTypeAndOutputType(inputFormat: DateformatterType.YYYY_MM_DD_T_HH_mm_ssZ.rawValue, outputFormat: DateformatterType.h_mm_a_DD_MMM_YYYY.rawValue)
        if notificationItem?.urlMedia != nil && notificationItem?.urlMedia != ""{
            imageView.kf.setImage(with: URL(string: (notificationItem?.urlMedia)!))
        }else{
            imageView.image = UIImage(named: "default_chart")
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDidTapImage)))
        imageView.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Detail Notification".localized()
    }
    //MARK: Helper Method
    @objc func handleDidTapImage(){
        let images = [LightboxImage(image: imageView.image!)]
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        // Use dynamic background.
        controller.dynamicBackground = true
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }

}
