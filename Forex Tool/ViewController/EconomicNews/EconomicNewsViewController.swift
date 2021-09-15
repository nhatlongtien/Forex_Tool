//
//  EconomicNewsViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/09/2021.
//

import UIKit
import WebKit
import PKHUD
class EconomicNewsViewController: UIViewController {

    @IBOutlet weak var newsWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadWebPage()
        newsWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Economic News"
    }
    //MARK: Helper Method
    func loadWebPage(){
        if let url = URL(string: Constant.economicNewsUrl){
            let request = URLRequest(url: url as URL)
            newsWebView.load(request)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            if Float(newsWebView.estimatedProgress) < 1.0{
                HUD.show(.systemActivity)
            }else{
                HUD.hide()
            }
        }
    }
}
