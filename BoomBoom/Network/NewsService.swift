//
//  NewsService.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/14/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class NewsService {
    let pathURL:String =  Constants.HTTP.PATH_URL
    var headers_urlencoded: HTTPHeaders = ["Content-Type":"application/json"]
    
    static let current = NewsService()
    private init(){}
    
    func getFirstTop100Photo(token:String, lang:String, completion: @escaping (Top100PhotoListAnswer?, NSError?)->Void){
        if let url = URL(string: "\(pathURL)/like/gettop/one") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: Top100PhotoListAnswer.self) { (model, error) in
                guard let model = model else {
                    completion(nil, error)
                    return
                }
                completion(model, nil)
            }
        }
    }
    
    func getNewAccounts(token:String, lang:String, page:Int, completion: @escaping (NewAccountListAnswer?, NSError?)->Void){
        if let url = URL(string: "\(pathURL)/accounts/getnew") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = ["page":page]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: NewAccountListAnswer.self) { (model, error) in
                guard let model = model else {
                    completion(nil, error)
                    return
                }
                completion(model, nil)
            }
        }
    }
}
