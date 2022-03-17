//
//  CardNumberFormatter.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import Foundation

//MARK: - Card Number Formatter
class CardNumberFormatter{
    /// return string to card number 4 digit group set  eg. :-  XXXX XXXX XXXX XXXX
    static var cardNumberLength:Int = 12
    static func formatterGroupFours(_ input: String) -> String {
        var groups: [String] = []
        
        
        for i in stride(from: 0, to: input.count < cardNumberLength - 1 ? input.count : cardNumberLength - 1, by: 4) {
            let startIndex = input.index(input.startIndex, offsetBy: i, limitedBy: input.endIndex) ?? input.startIndex
            let endIndex = input.index(startIndex, offsetBy: 4, limitedBy: input.endIndex) ?? input.endIndex
            groups.append(String(input[startIndex..<endIndex]))
        }
        
//        for i in stride(from: 0, to: input.count, by: 4) {
//            let startIndex = input.index(input.startIndex, offsetBy: i, limitedBy: input.endIndex) ?? input.startIndex
//            let endIndex = input.index(startIndex, offsetBy: 4, limitedBy: input.endIndex) ?? input.endIndex
//            groups.append(String(input[startIndex..<endIndex]))
//        }
        return groups.joined(separator: " ")
    }
    
    /// formater American Expresscc card Number wise eg. :- XXXX XXXXXX XXXXXX
    static func formatterAmex(_ input: String) -> String {
        var groups: [String] = []
        
        // first group
        var startIndex = input.index(input.startIndex, offsetBy: 0, limitedBy: input.endIndex) ?? input.startIndex
        var endIndex = input.index(startIndex, offsetBy: 4, limitedBy: input.endIndex) ?? input.endIndex
        groups.append(String(input[startIndex..<endIndex]))
        // second group
        startIndex = endIndex
        endIndex = input.index(startIndex, offsetBy: 6, limitedBy: input.endIndex) ?? input.endIndex
        if startIndex != endIndex { groups.append(String(input[startIndex..<endIndex])) }
        // third group
        startIndex = endIndex
        endIndex = /*input.endIndex*/input.index(startIndex, offsetBy: 6, limitedBy: input.endIndex) ?? input.endIndex
        if startIndex != endIndex { groups.append(String(input[startIndex..<endIndex])) }
        
        return groups.joined(separator: " ")
    }
}
