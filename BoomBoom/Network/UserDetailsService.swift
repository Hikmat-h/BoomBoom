//
//  UserDetailsService.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/27/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class UserDetailsSerice {
    
    let pathURL:String =  Constants.HTTP.PATH_URL
    var headers_urlencoded: HTTPHeaders = ["Content-Type":"application/json"]
    
    static let current = UserDetailsSerice()
    private init(){}
    
    func searchCountry(token:String, lang:String, title:String, page:Int, completion: @escaping (CountryListAnswerModel?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/directory/countries/get") {
        headers_urlencoded["Accept-Language"] = lang
        headers_urlencoded["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OCIsImlhdCI6MTU2OTc2NDY3MywiZXhwIjoxNTcwNjI4NjczfQ.BOjlMkdVzlh9V6rdTEEwPQuFz1gWuQh3cHaohpE2unAjlsr8C8wiD7M2hZYQx0Rz95Pdn6iqGIq8Z9_MatKXHA"
        let params: Parameters = ["title": title, "page": page]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: CountryListAnswerModel.self) { (model, error) in
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
    
    func searchCity(token:String, lang:String, countryId:Int, title:String, page:Int, completion: @escaping (CityListAnswerModel?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/directory/cities/get") {
        headers_urlencoded["Accept-Language"] = lang
        headers_urlencoded["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OCIsImlhdCI6MTU2OTc2NDY3MywiZXhwIjoxNTcwNjI4NjczfQ.BOjlMkdVzlh9V6rdTEEwPQuFz1gWuQh3cHaohpE2unAjlsr8C8wiD7M2hZYQx0Rz95Pdn6iqGIq8Z9_MatKXHA"
            let params: Parameters = ["title": title, "page": page, "countryId":countryId]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: CityListAnswerModel.self) { (model, error) in
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
    
    func getGender(token:String, lang:String, completion: @escaping (GenderListAnswer?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/directory/sex/get") {
        headers_urlencoded["Accept-Language"] = lang
        headers_urlencoded["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OCIsImlhdCI6MTU2OTc2NDY3MywiZXhwIjoxNTcwNjI4NjczfQ.BOjlMkdVzlh9V6rdTEEwPQuFz1gWuQh3cHaohpE2unAjlsr8C8wiD7M2hZYQx0Rz95Pdn6iqGIq8Z9_MatKXHA"
            let params: Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: GenderListAnswer.self) { (model, error) in
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
    
    func createBasicProfileData (token:String, lang:String, sexId:Int, email:String?, phone:String?, countryId:Int, cityId:Int, name:String, dateBirth:String, completion: @escaping (EditUserInfo?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/user/save") {
        headers_urlencoded["Accept-Language"] = lang
        headers_urlencoded["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OCIsImlhdCI6MTU2OTc2NDY3MywiZXhwIjoxNTcwNjI4NjczfQ.BOjlMkdVzlh9V6rdTEEwPQuFz1gWuQh3cHaohpE2unAjlsr8C8wiD7M2hZYQx0Rz95Pdn6iqGIq8Z9_MatKXHA"
            var params: Parameters = ["sexId":sexId, "countryId":countryId, "cityId":cityId, "name":name, "dateBirth":dateBirth]
            if phone != nil {
                params["phone"] = phone
            }
            if email != nil {
                params["email"] = email
            }
            AppNetwork.request(url: url, method: .post, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: EditUserInfo.self) { (model, error) in
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
