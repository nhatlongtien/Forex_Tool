//
//  CustomeBoderRadiusView.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import UIKit
@IBDesignable
class CustomeBoderRadiusView: UIView {

    @IBInspectable var radious:CGFloat = 5.0
    @IBInspectable var borderWidth:CGFloat = 1.0
    @IBInspectable var borderColor:UIColor = #colorLiteral(red: 0.8235294118, green: 0.8980392157, blue: 0.9960784314, alpha: 1)
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    override func awakeFromNib() {
        setupView()
    }
    func setupView(){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = radious
        self.clipsToBounds = true
    }

}
