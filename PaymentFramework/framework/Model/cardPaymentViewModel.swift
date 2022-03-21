//
//  cardPaymentviewModel.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 10/03/22.
//

import UIKit

//MARK: - Card Payment View Model
struct CardPaymentModel {
    
    //MARK: Shared Instance
    static let shared = CardPaymentModel()
    
    // MARK: Inputs
    var number: String?
    var name:String?
    var email:String?
    var expiryYear: Int?
    var expiryMonth: Int?
    var cvv: String?
    
    var currentYear: Int
    var currentMonth: Int
    
    var numberOfExpiryYears = 20
    var expiryFormatter = DateFormatter()
    
    var calendar: Calendar = .current
    
    fileprivate var expiryDate: Date? {
        guard let month = expiryMonth, let year = expiryYear else { return nil }
        var components = DateComponents()
        components.year = year
        components.month = month
        return calendar.date(from: components)
    }
    
    var cardBrandIcon: UIImage? {
        return brand.details.icon
    }
    
    //MARK: - Init Method
    init(currentYear: Int, currentMonth: Int) {
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        expiryFormatter.dateFormat = "MM/YY"
    }
    
    init(current date: Date = Date(), calendar: Calendar = .current) {
        let year = calendar.component(.year, from: date) % 100 // Simplify expects 2 digit years for card expiration
        let month = calendar.component(.month, from: date)
        self.init(currentYear: year, currentMonth: month)
        self.calendar = calendar
    }
}

// MARK: - Valid Check Properties
extension CardPaymentModel {
    var cardValid: Bool {
        return numberValid && cvvValid && expiryValid //expiryDateValid
    }
    
    var numberValid: Bool {
        guard let number = number else { return false }
        return brand.details.validateLength(cardNumber: number) && CardNumberValidator.validate(number)
    }
    
//    var expiryDateValid: Bool {
//        guard let expiryDate = expiryDate else { return false }
//        return ExpiryDateValidator.validateLength(expirydate: expiryDate) && ExpiryDateValidator.validDate(expirydate: expiryDate)
//    }
    
    var expiryValid: Bool {
        guard let expiryMonth = expiryMonth, let expiryYear = expiryYear else { return false }
        return expiryMonth >= currentMonth || expiryYear > currentYear
    }
    
    var cvvValid: Bool {
        guard let cvv = cvv else { return false }
        return CVVNumberValidator.validateLength(expirydate: cvv)
    }
}

// MARK: - Formate set Properties
extension CardPaymentModel{
   
    var formattedCardNumber: String? {
        get {
            guard let number = number else { return nil }
            return brand.details.numberFormatter(number)
        }
        set {
            if let newValue = newValue {
//                number = brand.details.numberFormatter(newValue)
                let num = normalizeCard(newValue)
                let changeNum = brand.details.numberFormatter(num)
                number = normalizeCard(changeNum)
            } else {
                number = newValue
            }
        }
    }
    
    var formattedExpiryDate: String? {
        guard let date = expiryDate else {
            return nil
        }
        return expiryFormatter.string(from: date)
    }
    
    
    var formattedExpiryCvv: String? {
        get {
            guard let cvv = cvv else { return nil }
            return CvvFormatter.formatterGroupCvv(cvv)
        }
        set {
            if let newValue = newValue {
                cvv = CvvFormatter.formatterGroupCvv(newValue)
            } else {
                cvv = newValue
            }
        }
    }
    //    var formattedExpiryDate: String? {
    //        get {
    //            guard let date = expiryDate else { return nil }
    //            return ExpiryDateFormatter.formatterGroupDate(date)
    //        }
    //        set {
    //            if let newValue = newValue {
    //                expiryDate = normalizeExpiryDate(newValue)
    //            } else {
    //                expiryDate = newValue
    //            }
    //        }
    //    }
}

// MARK: Expiration Picker Properties
extension CardPaymentModel{
    var expiryMonthValues: [Int] { return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] }
    var expiryYearValues: [Int] { return Array((currentYear ..< (currentYear + numberOfExpiryYears))) }
    var expiryMonthTitles: [String] {
        return expiryMonthValues.enumerated().map { "\(expiryFormatter.shortMonthSymbols[$0.offset])(\($0.element))" }
    }
    
    var expiryYearTitles: [String] {
        return expiryYearValues.map { "\($0 + 2000)" }
    }
    
    var selectedExpiryMonthIndex: Int {
        get {
            return expiryMonthValues.firstIndex(of: expiryMonth ?? currentMonth) ?? 0
        }
        set {
            expiryMonth = expiryMonthValues[newValue]
        }
    }
    
    var selectedExpiryYearIndex: Int {
        get {
            return expiryYearValues.firstIndex(of: expiryYear ?? currentYear) ?? 0
        }
        set {
            expiryYear = expiryYearValues[newValue]
        }
    }
    
    mutating func updateExpirySelection(month: Int, year: Int) {
        selectedExpiryMonthIndex = month
        selectedExpiryYearIndex = year
    }
    
    mutating func initiateExpiryEditing() {
        if expiryMonth == nil {
            expiryMonth = currentMonth
        }
        if expiryYear == nil {
            expiryYear = currentYear
        }
    }
}

//MARK: - FilePrivate Method
extension CardPaymentModel {
    fileprivate var brand: CardBrand {
        guard let number = number else { return .unknown }
        return CardBrand.detectBrand(number)
    }
    
    fileprivate func normalizeCard(_ number: String) -> String {
        return number.replacingOccurrences(of: "[^\\d]+", with: "", options: .regularExpression) // just the digits
    }
    
    fileprivate func normalizeExpiryDate(_ number: String) -> String {
        return number.prefix(5).replacingOccurrences(of: "/", with: "", options: .regularExpression) // just the digits
    }
    
    fileprivate func normalizeExpiryCvv(_ number: String) -> String {
        return number.replacingOccurrences(of: "", with: "", options: .regularExpression) // just the digits
    }
}

//MARK: - Card Brand Name Model
enum CardBrand: String {
    case visa = "VISA"
    case mastercard = "MASTERCARD"
    case americanExpress = "AMERICAN_EXPRESS"
    case discover = "DISCOVER"
    case diners = "DINERS"
    case jcb = "JCB"
    case unknown = "UNKNOWN"
}

//MARK: - Card Brand Properties
extension CardBrand {
    /// CardBrand detail properties add
    var details: Details {
        switch self {
        case .visa:
            CvvFormatter.cvvLength = 3
            CardNumberFormatter.cardNumberLength = 19
            return Details(icon: ImageConstant.imageCardVisa, validLengths: [13, 16, 19], cvcLength: 3, prefixPattern: "^4\\d*")
            
        case .mastercard:
            CvvFormatter.cvvLength = 3
            CardNumberFormatter.cardNumberLength = 16
            return Details(icon: ImageConstant.imageCardMasterCard, validLengths: [16], cvcLength: 3, prefixPattern: "^(?:5[1-5]|67)\\d*")
        case .americanExpress:
            CvvFormatter.cvvLength = 4
            CardNumberFormatter.cardNumberLength = 19
            return Details(icon: ImageConstant.imageCardAmericanExpress, validLengths: [15], cvcLength: 4, prefixPattern: "^3[47]\\d*", numberFormatter: CardNumberFormatter.formatterAmex)
            
        case .discover:
            CvvFormatter.cvvLength = 3
            CardNumberFormatter.cardNumberLength = 19
            return Details(icon: ImageConstant.imageCardDiscover, validLengths: [16, 17, 18, 19], cvcLength: 3, prefixPattern: "^6(?:011|4[4-9]|5)\\d*")
        case .diners:
            CvvFormatter.cvvLength = 3
            CardNumberFormatter.cardNumberLength = 19
            return Details(icon: ImageConstant.imageCardDiners, validLengths: [16], cvcLength: 3, prefixPattern: "^3(?:0(?:[0-5]|9)|[689])\\d*")
        case .jcb:
            CvvFormatter.cvvLength = 3
            CardNumberFormatter.cardNumberLength = 19
            return Details(icon: ImageConstant.imageCardJCB, validLengths: [16, 17, 18, 19], cvcLength: 3, prefixPattern: "^35(?:2[89]|[3-8])\\d*")
        case .unknown:
            CvvFormatter.cvvLength = 3
            CardNumberFormatter.cardNumberLength = 19
            return Details(icon: ImageConstant.imageCardUnknown, validLengths: [12, 13, 14, 15, 16, 17, 18, 19], cvcLength: 3)
        }
    }
    
    /// detect Brands
    static func detectBrand(_ number: String) -> CardBrand {
        return CardBrand.allValues.first(where: { $0.details.prefixMatches(number) }) ?? .unknown
    }
}

extension CardBrand {
    static var allValues: [CardBrand] {
        return [.visa, .mastercard, .americanExpress, .discover, .diners, .jcb, .unknown]
    }
}

// MARK: -  Details Stucture Model in Card Barand
extension CardBrand {
    struct Details {
        let icon: UIImage?
        let validLengths: [Int]
        let cvcLength: Int
        let prefixPattern: String?
        let numberFormatter: (String) -> String
        
        init(icon: UIImage?,validLengths: [Int], cvcLength: Int, prefixPattern: String? = nil, numberFormatter: @escaping (String) -> String = CardNumberFormatter.formatterGroupFours) {
            self.icon = icon
            self.validLengths = validLengths
            self.cvcLength = cvcLength
            self.prefixPattern = prefixPattern
            self.numberFormatter = numberFormatter
        }
    }
}

//MARK: - Details Model Method
extension CardBrand.Details {
    func prefixMatches(_ number: String) -> Bool {
        guard let prefixPattern = prefixPattern else { return true }
        return number.range(of: prefixPattern, options: .regularExpression) != nil
    }
}

extension CardBrand.Details {
    func validateLength(cardNumber cn: String) -> Bool {
        return validLengths.contains(cn.count)
    }
}

