//
//  UIFOntExtension.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 15/03/22.
//

import UIKit

//MARK: - UIFont Extension
extension UIFont {
    /// register Font in framework
    private static func registerFont(withName name: String, fileExtension: String) {
        let frameworkBundle = Bundle(identifier: StringConstant.BundleIdentifire)
        let pathForResourceString = frameworkBundle?.path(forResource: name, ofType: fileExtension)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            print("Error registering font")
        }
    }
    ///Load CREDCARD-ragular.ttf Font File
    public static func loadFonts() {
        registerFont(withName: "CREDCARD-ragular", fileExtension: ".ttf")
    }
}
