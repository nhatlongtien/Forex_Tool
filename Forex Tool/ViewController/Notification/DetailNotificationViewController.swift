//
//  DetailNotificationViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 20/10/2021.
//

import UIKit
import Kingfisher
import Lightbox
import GoogleMobileAds
class DetailNotificationViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var publicDateLbl: UILabel!
    @IBOutlet weak var titleTlb: UILabel!
//    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    var notificationItem:NotificationModel?
    var timer:Timer?
    //
    private var interstitial: GADInterstitialAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        contentTextView.isSelectable = true
        contentTextView.isEditable = false
        //
        titleTlb.text = notificationItem?.title?.uppercased()
//        contentLbl.text = notificationItem?.body
        contentTextView.text = notificationItem?.body?.replacingOccurrences(of: "\\n", with: "\n")
        publicDateLbl.text = notificationItem?.date?.formatDateWithInputTypeAndOutputType(inputFormat: DateformatterType.YYYY_MM_DD_T_HH_mm_ssZ.rawValue, outputFormat: DateformatterType.h_mm_a_DD_MMM_YYYY.rawValue)
        if notificationItem?.urlMedia != nil && notificationItem?.urlMedia != ""{
            imageView.kf.setImage(with: URL(string: (notificationItem?.urlMedia)!))
        }else{
            imageView.image = UIImage(named: "default_chart")
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDidTapImage)))
        imageView.isUserInteractionEnabled = true
        //
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTime), userInfo: nil, repeats: false)
        //
        downloadAds()
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
    func downloadAds(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-8162737912880549/2979491402",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        })
    }
    @objc func handleTime(){
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
    }
}
