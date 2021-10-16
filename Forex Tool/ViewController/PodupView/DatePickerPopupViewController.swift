//
//  DatePickerPopupViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/10/2021.
//

import UIKit
protocol DatePickerPopupViewControllerDelegate:class{
    func passData(fromDate:Date, toDate:Date)
}
class DatePickerPopupViewController: UIViewController {

    @IBOutlet weak var fromTitle: UILabel!
    @IBOutlet weak var toTitle: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    //
    weak var delegate:DatePickerPopupViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupUI()
        //
        fromDatePicker.maximumDate = Date()
        toDatePicker.minimumDate = fromDatePicker.date
        fromDatePicker.addTarget(self, action: #selector(handleFromDatePicker), for: .valueChanged)
    }
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseButtonWasPressed(_ sender: Any) {
        self.delegate?.passData(fromDate: fromDatePicker.date, toDate: toDatePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Helper Method
    @objc func handleFromDatePicker(){
        toDatePicker.minimumDate = fromDatePicker.date
    }
    func setupUI(){
        fromTitle.text = "From".localized()
        toTitle.text = "To".localized()
        chooseButton.setTitle("Choose".localized(), for: .normal)
    }
}
