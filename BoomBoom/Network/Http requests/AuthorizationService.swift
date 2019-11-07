//
//  AuthorizationService.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/25/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class AuthorizationService {
    
    let pathURL:String =  Constants.HTTP.PATH_URL
    let headers_urlencoded: HTTPHeaders = ["Content-Type":"application/json"]
    
    static let current = AuthorizationService()
    
    private init(){}
    
    
    //авторизация нового пользователя
    func authorizationUser(mail:String, password:String, completion: @escaping (AuthByMailNetworkResponseModel?, NSError?) -> Void ) {
        if let forecastUrl = URL(string: "\(pathURL)/auth/login") {
            let params: Parameters = ["email":mail, "password":password]
            AppNetwork.request(url: forecastUrl, method: .post, params: params, encoding: JSONEncoding.default, headers: headers_urlencoded, codableClass: AuthByMailNetworkResponseModel.self) { (model, error) in
                guard let model = model else {
                    if((error) != nil){
                        completion(nil, error)
                    }
                    return
                }
                completion(model, nil)
            }
        }
    }
    
    //returns code to authorize
    func authorizationUserByPhone(phone:String, completion: @escaping ([String: AnyObject]?, NSError?) -> Void ) {
        if let forecastUrl = URL(string: "\(pathURL)/auth/getsms/test") {
            let params: Parameters = ["mobilePhone":phone]
            Alamofire.request(forecastUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers_urlencoded).responseJSON { ( response) in
                
                guard let code = response.response?.statusCode else {
                    completion(nil, NSError(domain: "Connection error", code: 122, userInfo: nil))
                    return
                }
                
                guard let data = response.data else { return }
                
                if code >= 200 && code < 300 {
                    if let value = response.result.value as? [String: AnyObject] {
                    completion(value, nil)}
                } else {
                    let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    completion(nil, NSError(domain: error?.message ?? "", code: code, userInfo: nil))
                }
                completion(nil, response.error as NSError?)
            }
        }
    }
    
    //sends sms code
    func authorizationBySmsCode(phone: String, code: String, completion: @escaping (AuthByMailNetworkResponseModel?, NSError?) -> Void) {
        if let url = URL(string: "\(pathURL)/auth/sendsms") {
            let params: Parameters = ["mobilePhone": phone, "code":code]
            AppNetwork.request(url: url, method: .post, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: AuthByMailNetworkResponseModel.self) { (model, error) in
                guard let model = model else {
                    if error != nil {
                        completion(nil, error)
                    }
                    return
                }
                completion(model, nil)
            }
        }
    }
}

