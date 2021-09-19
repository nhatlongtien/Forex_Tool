//
//  String Extension.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 08/07/2021.
//

import Foundation
extension String{
    //Valadate email
    func isValadateEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    //Valadate password
    func isValadatePasswprd() -> Bool {
        let passwordRegEX = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#.?!@$%^&*-]).{8,20}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEX)
        return passwordPred.evaluate(with: self)
    }
    //
    //Divide string into equal parts (reading: from right to left)
    func split(by length:Int) -> [Substring] {
        guard length > 0 && length < count else { return [suffix(from:startIndex)] }

        return (0 ... (count - 1) / length).map { dropLast($0 * length).suffix(length) }.reversed()
    }
    //Convert string to date
    func formartDate(inputFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = inputFormat
        return dateFormatter.date(from: self) ?? Date()
    }
}
extension Double{
    func formaterValueOfPips() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "EN")
        numberFormatter.groupingSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        let stringNumber = numberFormatter.string(from: NSNumber(value: self))
        return stringNumber!
    }
    func formaterCurrentPriceWith3FractionDigits() -> String{
        let numberFormater = NumberFormatter()
        numberFormater.locale = Locale(identifier: "EN")
        numberFormater.groupingSeparator = ","
        numberFormater.numberStyle = .decimal
        numberFormater.maximumFractionDigits = 3
        numberFormater.minimumFractionDigits = 3
        let stringNumber = numberFormater.string(from: NSNumber(value: self))
        return stringNumber!
    }
    func formaterCurrentPriceWithFiveFractionDigits() -> String{
        let numberFormater = NumberFormatter()
        numberFormater.locale = Locale(identifier: "EN")
        numberFormater.groupingSeparator = ","
        numberFormater.numberStyle = .decimal
        numberFormater.maximumFractionDigits = 5
        numberFormater.minimumFractionDigits = 5
        let stringNumber = numberFormater.string(from: NSNumber(value: self))
        return stringNumber!
    }
    func formaterCurrentPriceWithTwoFractionDigits() -> String{
        let numberFormater = NumberFormatter()
        numberFormater.locale = Locale(identifier: "EN")
        numberFormater.groupingSeparator = ","
        numberFormater.numberStyle = .decimal
        numberFormater.maximumFractionDigits = 2
        numberFormater.minimumFractionDigits = 2
        let stringNumber = numberFormater.string(from: NSNumber(value: self))
        return stringNumber!
    }
    func round(to places: Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return Darwin.round(self * divisor) / divisor
        }
    
    
}
extension Date{
    func dateToString(format:String, locale:Locale = Locale.current) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
}
