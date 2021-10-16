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
    //Validate phone number
    func isValidatePhoneNumber() -> Bool{
        let phoneNumberRegEx = "[0-9]{6,20}"
        let phoneNumberPred = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberPred.evaluate(with: self)
    }
    //Validate full name
    func isValidateFullName() ->Bool{
        let nameRegEx = "[a-zA-ZàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ\\s]*"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        if self.count >= 6 && self.count <= 50 && namePred.evaluate(with: self){
            return true
        }else{
            return false
        }
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
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self) ?? Date()
    }
    //filter String to get digit
    func digits() -> String{
        return self.filter("0123456789.".contains)
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
    func numberFractionDigits( number: Int) -> String{
        let numberFormater = NumberFormatter()
        numberFormater.locale = Locale(identifier: "EN")
        numberFormater.groupingSeparator = ","
        numberFormater.numberStyle = .decimal
        numberFormater.maximumFractionDigits = number
        numberFormater.minimumFractionDigits = number
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
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    var startOfMonth:Date{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    var endOfMonth:Date{
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    var startOfYear:Date{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    var endOfYear:Date{
        return Calendar.current.date(byAdding: DateComponents(year: 1), to: self.startOfYear)!
    }
    
}
