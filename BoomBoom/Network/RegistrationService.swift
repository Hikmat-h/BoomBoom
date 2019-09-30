//
//  RegistrationService.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/27/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class RegistrationService {
    
    let pathURL:String =  Constants.HTTP.PATH_URL
    let headers_urlencoded: HTTPHeaders = ["Content-Type":"application/json"]
       
    static let current = RegistrationService()
    private init(){}
    
    func registrationByEmail(mail: String, password: String, completion: @escaping (AuthByMailNetworkResponseModel?, NSError?)->Void ) {
        if let url = URL(string: "\(pathURL)/auth/reg") {
            let params: Parameters = ["email": mail, "password": password]
            AppNetwork.request(url: url, method: .post, params: params, encoding: JSONEncoding.default, headers: headers_urlencoded, codableClass: AuthByMailNetworkResponseModel.self) { (model, error) in
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
