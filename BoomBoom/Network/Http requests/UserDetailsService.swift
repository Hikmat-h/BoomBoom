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
            headers_urlencoded["Authorization"] = "Bearer \(token)"
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
            headers_urlencoded["Authorization"] = "Bearer \(token)"
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
    
    func createBasicProfileData (token:String, lang:String, sexId:Int, email:String?, phone:String?, countryId:Int, cityId:Int, name:String, dateBirth:String, completion: @escaping (UserInfo?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/user/save") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            var params: Parameters = ["sexId":sexId, "countryId":countryId, "cityId":cityId, "name":name, "dateBirth":dateBirth]
            if phone != nil {
                params["phone"] = phone
            }
            if email != nil {
                params["email"] = email
            }
            AppNetwork.request(url: url, method: .post, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: UserInfo.self) { (model, error) in
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
    
    func editProfileData(token:String,
                         lang:String,
                         bodyTypeId:Int,
                         sexId:Int,
                         sexualOrientation:Int,
                         countryId:Int,
                         cityId:Int,
                         name:String,
                         dateBirth:String,
                         information:String,
                         weight:Int,
                         height:Int,
                         breastSize:Int?,
                         pdSponsorship:Bool,
                         pdSpendEvening:Bool,
                         pdPeriodicMeetings:Bool,
                         pdTravels:Bool,
                         pdFriendshipCommunication:Bool,
                         hobby:String,
                         favoritePlacesCity:String,
                         visitedCountries:String,
                         countriesWantVisit:String,
                         hairColorId:Int,
                         completion: @escaping (UserInfo?, NSError?)->Void) {
       if let url = URL(string: "\(pathURL)/user/save") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            var params: Parameters = ["bodyTypeId":bodyTypeId, "sexId":sexId, "sexualOrientation":sexualOrientation, "countryId":countryId, "cityId":cityId, "name":name, "dateBirth":dateBirth, "information":information, "weight":weight, "height":height, "pdSponsorship":pdSponsorship, "pdSpendEvening":pdSpendEvening, "pdPeriodicMeetings":pdPeriodicMeetings, "pdTravels":pdTravels, "pdFriendshipCommunication":pdFriendshipCommunication, "hobby":hobby, "favoritePlacesCity":favoritePlacesCity, "visitedCountries":visitedCountries, "countriesWantVisit":countriesWantVisit, "hairColorId":hairColorId]
            if breastSize != nil {
                params["breastSize"] = breastSize
            }
            AppNetwork.request(url: url, method: .post, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: UserInfo.self) { (model, error) in
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
    
    func getProfileDetails(token:String, lang:String, completion: @escaping (UserInfo?, NSError?)->Void) {
        if let url = URL(string: "\(pathURL)/user/get") {
            headers_urlencoded["Accept-Language"] = lang
                   headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params:Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: UserInfo.self) { (model, error) in
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
            headers_urlencoded["Authorization"] = "Bearer \(token)"
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
    
    func getHairColor(token:String, lang:String, completion: @escaping (HairListAnswer?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/directory/haircolor/get") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: HairListAnswer.self) { (model, error) in
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
    
    func getBodyType(token:String, lang:String, completion: @escaping (BodyTypeListAnswer?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/directory/bodytype/get") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: BodyTypeListAnswer.self) { (model, error) in
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
    
    func getOrientation(token:String, lang:String, completion: @escaping (OrientationListAnswer?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/directory/sexualorientation/get") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: OrientationListAnswer.self) { (model, error) in
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
    
    func getVerification(token:String, lang:String, completion: @escaping (VerificationModel?, NSError?)-> Void) {
        if let url = URL(string: "\(pathURL)/verification/get") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = [:]
            AppNetwork.request(url: url, method: .get, params: params, encoding: URLEncoding.default, headers: headers_urlencoded, codableClass: VerificationModel.self) { (model, error) in
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
    
    func setPhoto(token:String, lang:String, image:UIImage, completion: @escaping (NSError?)->Void) {
        let imgData = image.jpegData(compressionQuality: 1.0)!
        if let url = URL(string: "\(pathURL)/user/photo/set") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            Alamofire.upload( multipartFormData: { (multiPartFormData) in
                multiPartFormData.append(imgData, withName: "photo", fileName: "file.jpg", mimeType: "image/jpg")
            }, to: url, headers: headers_urlencoded) { (result) in
                switch result {
                case .success(let upload, _, _):
                    //progress block
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    //success block
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        completion(nil)
                    }

                case .failure(let encodingError):
                    print(encodingError)
                    completion(encodingError as NSError)
                }
            }
        }
    }
    
    func deletePhoto(token:String, lang:String, photoID:Int, completion: @escaping (PhotoListAnswer?, NSError?)->Void) {
       if let url = URL(string: "\(pathURL)/user/photo/delete") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = ["id":photoID]
            AppNetwork.request(url: url, method: .delete, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: PhotoListAnswer.self) { (model, error) in
                if error == nil {
                    completion(model, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func makePhotoAvatar(token:String, lang:String, photoID:Int, completion: @escaping (PhotoListAnswer?, NSError?)->Void) {
       if let url = URL(string: "\(pathURL)/user/photo/avatar") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            let params: Parameters = ["photoId":photoID]
            AppNetwork.request(url: url, method: .post, params: params, encoding: URLEncoding.queryString, headers: headers_urlencoded, codableClass: PhotoListAnswer.self) { (model, error) in
                if error == nil {
                    completion(model, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }

}
