//
//  CVVValidation.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import Foundation

//MARK: - Cvv Number Validator 
class CVVNumberValidator{
    /// expiry date Validation Length
    static var validLengths:[Int] {
       return [CvvFormatter.cvvLength]
    }
    /// check Cvv number is Valid Length or not
    static func validateLength(expirydate cn: String) -> Bool {
        return CVVNumberValidator.validLengths.contains(cn.count)
    }
}
