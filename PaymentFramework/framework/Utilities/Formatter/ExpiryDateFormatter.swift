//
//  ExpiryDateFormatter.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import Foundation

//MARK: - Expiry Date Formatter
class ExpiryDateFormatter{
    /// return string Expiry date Formate set
    static func formatterGroupDate(_ input: String) -> String {
        var groups: [String] = []

        for i in stride(from: 0, to: input.count < 4 ? input.count : 4, by: 2) {
            let startIndex = input.index(input.startIndex, offsetBy: i, limitedBy: input.endIndex) ?? input.startIndex
            let endIndex = input.index(startIndex, offsetBy: 2, limitedBy: input.endIndex) ?? input.endIndex
            groups.append(String(input[startIndex..<endIndex]))
        }

        return groups.joined(separator: "/")
    }
    
}
