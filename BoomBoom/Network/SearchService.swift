//
//  SearchService.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/17/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class SearchService {
    let pathURL:String =  Constants.HTTP.PATH_URL
    var headers_urlencoded: HTTPHeaders = ["Content-Type":"application/json"]
    
    static let current = SearchService()
    private init(){}
    
    func searchAccounts(token:String,
                        lang:String,
                        yearFrom:Int,
                        yearTo:Int,
                        sex:String,
                        heightFrom:Int,
                        heightTo:Int,
                        weightFrom:Int,
                        weightTo:Int,
                        pdSponsorship:Bool,
                        pdSpendEvening:Bool,
                        pdPeriodicMeetings:Bool,
                        pdTravels:Bool,
                        pdFriendshipCommunication:Bool,
                        countryId:Int?,
                        cityId:Int?,
                        page:Int,
                        completion: @escaping (SearchResultList?, NSError?)->Void){
        if let url = URL(string: "\(pathURL)/accounts/search") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            var params: Parameters = ["yearFrom":yearFrom, "yearTo":yearTo, "sex":sex, "heightFrom":heightFrom, "heightTo":heightTo, "weightFrom":weightFrom, "weightTo":weightTo, "pdSponsorship":pdSponsorship, "pdSpendEvening":pdSpendEvening, "pdPeriodicMeetings":pdPeriodicMeetings, "pdTravels":pdTravels, "pdFriendshipCommunication":pdFriendshipCommunication, "page":page]
            if (countryId != nil) {
                params["countryId"] = countryId
            }
            if cityId != nil {
                params["cityId"] = cityId
            }
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: SearchResultList.self) { (model, error) in
                guard let model = model else {
                    completion(nil, error)
                    return
                }
                completion(model, nil)
            }
        }
    }
}
