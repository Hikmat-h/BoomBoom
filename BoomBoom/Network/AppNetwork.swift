//
//  AppNetwork.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/25/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class AppNetwork {
    
    
    public static func request<T: Codable>(
        url: URL,
        method: HTTPMethod,
        params: Parameters,
        encoding: ParameterEncoding,
        headers: HTTPHeaders,
        codableClass: T.Type,
        completion: @escaping ((_ model: T?, _ error: NSError?) -> Void)) {
        
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers).responseJSON { (response) in
            
            guard let code = response.response?.statusCode else {
                completion(nil, NSError(domain: "Connection error", code: 122, userInfo: nil))
                return
            }
            
            guard let data = response.data else { return }
            
            if code >= 200 && code < 300 {
                
                let detail = try? JSONDecoder().decode(T.self, from: data)
                completion(detail, nil)
            } else {
                let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(nil, NSError(domain: error?.message ?? "", code: code, userInfo: nil))
            }
        }
    }
}

struct ErrorResponse: Codable {
    let timestamp: String
    let status: Int
    let error, message, path: String
}
