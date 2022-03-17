//
//  ExpiryDateValidation.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import Foundation

//MARK: - Expiry Date Validation
class ExpiryDateValidator{
    
    /// expiry date Validation Length
    static var validLengths = [4]
    
    /// check expiry date length is velid or not
    static func validateLength(expirydate cn: String) -> Bool {
        return ExpiryDateValidator.validLengths.contains(cn.count)
    }
    
    /// check expiry date month and year is valid or not
    static func validDate(expirydate :String) -> Bool{
        let currentDate = Date()
        let MonthFormatter = DateFormatter()
        MonthFormatter.dateFormat = "MM"
        let YearFormatter = DateFormatter()
        YearFormatter.dateFormat = "YY"
        var MaxYear: String {
            return ""
        }
        if(MonthFormatter.string(from: currentDate) <= expirydate.prefix(2) && "12" >= expirydate.prefix(2)) && (YearFormatter.string(from: currentDate) <= expirydate.suffix(2)){
            return true
        }
        else{
            return false
        }
    }
}
