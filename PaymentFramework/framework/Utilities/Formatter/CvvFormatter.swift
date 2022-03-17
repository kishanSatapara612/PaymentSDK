//
//  CvvFormatter.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import Foundation

//MARK: -CVV Number Formatter
class CvvFormatter{
    
    static var cvvLength:Int = 3
    
    static func formatterGroupCvv(_ input: String) -> String {
        var groups: [String] = []
        
        for i in stride(from: 0, to: input.count < cvvLength - 1 ? input.count : cvvLength - 1 , by: cvvLength) {
            let startIndex = input.index(input.startIndex, offsetBy: i, limitedBy: input.endIndex) ?? input.startIndex
            let endIndex = input.index(startIndex, offsetBy: cvvLength, limitedBy: input.endIndex) ?? input.endIndex
            groups.append(String(input[startIndex..<endIndex]))
        }
        return groups.joined()
    }
}
