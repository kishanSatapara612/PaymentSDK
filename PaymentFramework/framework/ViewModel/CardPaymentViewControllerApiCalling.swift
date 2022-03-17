//
//  Extension.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 16/03/22.
//

import UIKit

class CardPaymentViewModel{
    
    //MARK: Shared Instance
    static let shared = CardPaymentViewModel()
    
    var showError: ((Error?)->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var modelDidSet: (()->())?
    
    var cardPaymentmodel:CardPaymentModel = CardPaymentModel.shared {
        didSet{
            guard let modelDidSet = modelDidSet else {
                return
            }
            modelDidSet()
        }
    }
    
    
    func start(){
        guard let showLoading = showLoading else {
            return
        }
        showLoading()
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.REGISTER_API, body: ["email":cardPaymentmodel.email ?? ""]) { data, error in
            guard let data = data else {
                guard let showError = self.showError else {
                    return
                }
                showError(error)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIManager.ApiKey.self, from: data)
                APIManager.shared.apikey = resp.apikey
            }
            catch{
                guard let showError = self.showError else {
                    return
                }
                showError(error)
            }
        }
        
        APIManager.shared.getPostData(url: APIManager.Constants.URLs.TOKENIZE_API, body: ["plaintext":["number":cardPaymentmodel.number,"expiry":"\(cardPaymentmodel.expiryMonth ?? 00)/\(cardPaymentmodel.expiryYear ?? 00 )","cvv":cardPaymentmodel.cvv]], apikey: APIManager.shared.apikey) { data, error in
            guard let data = data else {
                guard let showError = self.showError else {
                    return
                }
                showError(error)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIManager.Token.self, from: data)
                APIManager.shared.token = resp.token
            }
            catch{
                guard let showError = self.showError else {
                    return
                }
                showError(error)
            }
        }
    }
}
