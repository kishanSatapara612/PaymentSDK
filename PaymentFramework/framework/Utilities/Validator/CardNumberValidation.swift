//
//  CardNumberValidation.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import Foundation


//MARK: - CardNumber Validation
struct CardNumberValidator {
    /// check card number is valid or not
    static func validate(_ number: String) -> Bool {
        // get a reversed array of integers
        let digits = Array(number).compactMap { Int("\($0)") }.reversed()
        
        // sum the digits, doubling the odd digits
        let sum = digits.enumerated().reduce(0) { (sum, digit) -> Int in
            // only double the odd digits
            if digit.offset % 2 == 0 {
                return sum + digit.element
            }
            let value = digit.element * 2 // double the digit value
            return sum + ( value > 9 ? value - 9 : value) // if the doubled value is over 9, subtract 9
        }
        // the check passes if the sum is a multiple of 10
        return sum % 10 == 0
    }
}
