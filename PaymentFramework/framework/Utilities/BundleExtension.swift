//
//  BundleExtension.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 17/03/22.
//

import Foundation

extension Bundle {
    static var CardPaymentSDK: Bundle? {
        return Bundle(identifier: StringConstant.BundleIdentifire)
    }
}
