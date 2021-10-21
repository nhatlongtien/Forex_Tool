//
//  HelperMethod.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import Foundation
import UIKit
import JGProgressHUD
class HelperMethod{
    static var appDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    static func showAlertWithMessage(message:String){
        let alert = UIAlertController(title: "Alert".localized(), message: message, preferredStyle: UIAlertController.Style.alert)
        let btn_OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(btn_OK)
        if (appDelegate?.window?.visibleViewController?.isKind(of: UIAlertController.self))!{
            print("Alert is presenting")
        }else{
            appDelegate?.window?.visibleViewController?.present(alert, animated: true, completion: nil)
        }
        appDelegate?.window?.makeKeyAndVisible()
    }
    static func filterString(input:String, numberDigitAfterDecimal:Int) -> String{
        var strReturn = ""
        var strBefore = ""
        if input == ""{
            return input
        }else{
            if input.contains(".") == true{ // check input string contain "." or not
                let components = input.components(separatedBy: ".") //divide input string to two part: before dot and after dot
                let strAfterDecimal = components.last!
                let strBeforeDecimal = components.first!
                let splitArr = strBeforeDecimal.split(by: 3)
                strBefore = splitArr.joined(separator: ",")
                //
                strReturn = strBefore + "."
                let arrAffterDecimal = Array(strAfterDecimal)
                if arrAffterDecimal.count > numberDigitAfterDecimal {
                    for i in 0...numberDigitAfterDecimal - 1{
                        strReturn = strReturn + String(arrAffterDecimal[i])
                    }
                }else{
                    strReturn = strReturn + strAfterDecimal
                }
                return strReturn
            }else{ // not contain "." in input string
                if input.first == "0" && input.count >= 2{
                    var newInput = input
                    let splitArr = String(newInput.removeFirst()).split(by: 3)
                    strReturn = splitArr.joined(separator: ",")
                    return strReturn
                }else{
                    let splitArr = input.split(by: 3)
                    strReturn = splitArr.joined(separator: ",")
                    return strReturn
                }
            }
        }
    }
    static func convertDateToString(date:Date, dateFormater:String) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = dateFormater
        return formatter.string(from: date)
    }
    static func setRootToDashboardVC(){
        let targetVC = TabBarViewController()
        let navController = UINavigationController(rootViewController: targetVC)
        appDelegate?.window?.rootViewController = navController
        
    }
    static func setRootToViewControler(targetVC:UIViewController){
        let navController = UINavigationController(rootViewController: targetVC)
        appDelegate?.window?.rootViewController = navController
    }
        
}



