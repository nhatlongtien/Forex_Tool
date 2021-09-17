//
//  DetailNewsViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 17/09/2021.
//

import UIKit
import WebKit
import PKHUD
class DetailNewsViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    var selectedNewsItem:NewsItem?
    var titleScreen:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadWebPage()
        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = titleScreen
    }
    //MARK: Helper Method
    func loadWebPage(){
        guard let urlString = selectedNewsItem?.linkDetail else {return}
        if let url = URL(string: urlString){
            let request = URLRequest(url: url as URL)
            webview.load(request)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            if Float(webview.estimatedProgress) < 1.0{
                HUD.show(.systemActivity)
            }else{
                HUD.hide()
            }
        }
    }

}
