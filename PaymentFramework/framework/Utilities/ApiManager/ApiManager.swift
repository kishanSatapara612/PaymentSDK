//
//  ApiMsnager.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 12/03/22.
//

import UIKit

class APIManager{
    
    //MARK: Shared Instance
    static let shared = APIManager()
    
    var apikey:String?
    var token:String?
    
    //MARK: - Constant
    struct Constants {
        struct URLs {
            static var  BASE_API:String = "https://getway_id.execute-api.eu-west-1.amazonaws.com/staging/api"
            static var REGISTER_API:String {
                return Constants.URLs.BASE_API+"/users/register"
            }
            static var TOKENIZE_API:String {
                return Constants.URLs.BASE_API+"/tk/toknize"
            }
            static var FORWARD_API:String {
                return Constants.URLs.BASE_API+"/tk/forward"
            }
        }
        
        struct ResponseKey {
            static let code                         = "status_code"
            static let data                         = "data"
            static let ResponseMessage              = "ResponseMessage"
            static let list                         = "list"
        }
        
        struct ResponseCode {
            static let kArrSuccessCode              = [200,201]
            static let kErrorCode                   = 400
            static let kUnAuthorizeCode             = 401
            static let kNotFound                    = 404
        }
    }
    
    internal struct HTTPMethods {
        static let httpMethodPost = "POST"
        static let contentTypeHeader = "Content-Type"
        static let AuthorizationHeader = "Authorization"
        static let userAgentHeader = "User-Agent"
        static let jsonContentType = "application/json"
        
    }
    
    struct ApiKey:Decodable{
        var apikey:String?
    }
    
    struct Token:Decodable{
        var token:String? = nil
    }
}

extension APIManager{
    func getPostData(url:String,body:[String:Any],apikey:String? = nil,complitionHandler: @escaping(Data?,Error?)-> ()){
        guard let url = URL(string: url) else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.httpMethodPost
        request.addValue(HTTPMethods.contentTypeHeader, forHTTPHeaderField: HTTPMethods.jsonContentType)
        if let apikey = apikey {
            request.addValue(apikey, forHTTPHeaderField: HTTPMethods.AuthorizationHeader)
        }
        
        // prepare json data
        let json: [String: Any] = body
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                complitionHandler(nil, error)
                return
            }
            complitionHandler(data, nil)
        }
        task.resume()
    }
    
}



//    private func getApiKey(email:String,complitionHandler: @escaping(Bool,Error?)-> ()){
//        guard let url = URL(string: Constants.URLs.REGISTER_API) else{ return }
//        var request = URLRequest(url: url)
//        request.httpMethod = HTTPMethods.httpMethodPost
//        request.addValue(HTTPMethods.contentTypeHeader, forHTTPHeaderField: HTTPMethods.jsonContentType)
//        // prepare json data
//        let json: [String: Any] = ["email":email]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                complitionHandler(false, error)
//                return
//            }
//            do{
//                let resp = try JSONDecoder().decode(ApiKey.self, from: data)
//                self.apikey = resp.apikey
//                complitionHandler(true, nil)
//            }
//            catch{
//                print(error)
//                complitionHandler(false, error)
//            }
//        }
//        task.resume()
//    }
//
//    private func getToken(number:String,expiry:String,cvv:String,complitionHandler: @escaping(Bool,Error?)-> ()){
//
//        guard let url = URL(string: Constants.URLs.TOKENIZE_API) else{ return }
//        var request = URLRequest(url: url)
//        request.httpMethod = HTTPMethods.httpMethodPost
//        request.addValue(HTTPMethods.contentTypeHeader, forHTTPHeaderField: HTTPMethods.jsonContentType)
//        request.addValue(apikey ?? "", forHTTPHeaderField: HTTPMethods.AuthorizationHeader)
//        // prepare json data
//        let json: [String:[String: Any]] = ["plaintext":["number":number,"expiry":expiry,"cvv":cvv]]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                complitionHandler(false, error)
//                return
//            }
//            do{
//                let resp = try JSONDecoder().decode(Token.self, from: data)
//                self.token = resp.token
//                complitionHandler(true, nil)
//            }
//            catch{
//                print(error)
//                complitionHandler(false, error)
//            }
//        }
//        task.resume()
//    }
//
//    func getForword(number:String,expiry:String,cvv:String,complitionHandler: @escaping(Bool,Error?)-> ()){
//        guard let url = URL(string: Constants.URLs.TOKENIZE_API) else{ return }
//        var request = URLRequest(url: url)
//        request.httpMethod = HTTPMethods.httpMethodPost
//        request.addValue(HTTPMethods.contentTypeHeader, forHTTPHeaderField: HTTPMethods.jsonContentType)
//        request.addValue(apikey ?? "", forHTTPHeaderField: HTTPMethods.AuthorizationHeader)
//        // prepare json data
//        let json: [String: Any] = ["number":number,"expiry":expiry,"cvv":cvv]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                complitionHandler(false, error)
//                return
//            }
//            do{
//                let resp = try JSONDecoder().decode(Token.self, from: data)
//                self.token = resp.token
//                complitionHandler(true, nil)
//            }
//            catch{
//                print(error)
//                complitionHandler(false, error)
//            }
//        }
//        task.resume()
//    }
    
//    getApiKey(email: email) { status, error in
//        if status{
//            getToken(number:number,expiry:expiry,cvv:cvv) { status, error in
//                if status{
//
//                }
//                else{
//                    complitionHandler(status,error)
//                }
//            }
//        }
//        else{
//            complitionHandler(status,error)
//        }
//    }
    
    
    
    
//}
