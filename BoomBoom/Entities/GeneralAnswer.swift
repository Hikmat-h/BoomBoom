//
//  GeneralAnswer.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/25/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generalAnswer = try? newJSONDecoder().decode(GeneralAnswer.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGeneralAnswer { response in
//     if let generalAnswer = response.result.value {
//       ...
//     }
//   }

typealias GenderListAnswer = [GenderModel]

typealias HairListAnswer = [HairModel]

typealias BodyTypeListAnswer = [BodyType]

typealias OrientationListAnswer = [SexualOrientationModel]

typealias CityListAnswerModel = [City]

typealias CountryListAnswerModel = [Country]

typealias PhotoListAnswer = [Photo]

typealias NewAccountListAnswer = [NewAccount]

typealias Top100PhotoListAnswer = [Top100Account]

typealias SearchResultList = [SearchResult]

struct AuthByMailNetworkResponseModel: Codable {
    let accessToken, tokenType: String
}

struct GenderModel: Codable {
    let id: Int
    let title: String
}

struct HairModel: Codable {
    let id: Int
    let title: String
}

struct VerificationModel: Codable {
    let id: Int
    let pathURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case pathURL = "pathUrl"
    }
}


struct SexualOrientationModel: Codable {
    let id: Int
    let title: String
}

// MARK: - UserInfo  all info about user
struct UserInfo: Codable {
    let id: Int
    let name, dateBirth: String
    let countries: Country
    let cities: City
    let information: String?
    let sexualOrientation: SexualOrientationModel?
    let bodyType: BodyType?
    let sex: GenderModel
    let weight, height: Int
    let breastSize:Int?
    let pdSponsorship, pdSpendEvening, pdPeriodicMeetings, pdTravels: Bool
    let pdFriendshipCommunication: Bool
    let hobby, favoritePlacesCity, visitedCountries, countriesWantVisit: String?
    let photos: [Photo]
    let email: String?
    let phone: String?
    let hairColor: HairModel?
    let verification: BodyType
}

// MARK: - other user info
struct OtherProfile: Codable {
    let id: Int
    let name, dateBirth: String
    let countries: Country
    let cities: City
    let information: String?
    let sexualOrientation: SexualOrientationModel?
    let bodyType: BodyType?
    let sex: GenderModel
    let weight, height: Int
    let breastSize: Int?
    let pdSponsorship, pdSpendEvening, pdPeriodicMeetings, pdTravels: Bool
    let pdFriendshipCommunication: Bool
    let hobby: String?
    let favoritePlacesCity, visitedCountries, countriesWantVisit: String?
    let photos: [Photo]
    let hairColor: HairModel?
    let verification: BodyType
    let online: Bool
    let typeAccount: String
}

// MARK: - BodyType
struct BodyType: Codable {
    let id: Int
    let title: String
}

// MARK: - Cities
struct City: Codable {
    let cityID, countryID: Int
    let title: String
    let region: String?

    enum CodingKeys: String, CodingKey {
        case cityID = "cityId"
        case countryID = "countryId"
        case title, region
    }
}

// MARK: - Countries
struct Country: Codable {
    let countryID: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case countryID = "countryId"
        case title
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id: Int
    let pathURL, pathURLPreview: String
    let main: Bool?
    let cntLike: Int?
    var ilike: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case pathURL = "pathUrl"
        case pathURLPreview = "pathUrlPreview"
        case main, cntLike, ilike
    }
}

// MARK: - firstTop100
struct Top100Account: Codable {
    let id: Int
    let pathURL, pathURLPreview: String
    let accountID, cntLike: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case pathURL = "pathUrl"
        case pathURLPreview = "pathUrlPreview"
        case accountID = "accountId"
        case cntLike
    }
}

// MARK: - NewAccount
struct NewAccount: Codable {
    let id: Int
    let name: String
    let photos: [Photo]
    let dateBirth: String
    let cities: City
    let typeAccount: String
    let online: Bool
}

// MARK: - Photo
//struct NewAccountPhoto: Codable {
//    let id: Int
//    let pathURL, pathURLPreview: String
//    let main: Bool
//    let cntLike: Int
//    let ilike: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case pathURL = "pathUrl"
//        case pathURLPreview = "pathUrlPreview"
//        case main, cntLike, ilike
//    }
//}

// MARK: - SearchResult photo
struct SearchResultPhoto: Codable {
    let id: Int
    let pathURL, pathURLPreview: String
    let main: Bool
    let ilike: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case pathURL = "pathUrl"
        case pathURLPreview = "pathUrlPreview"
        case main, ilike
    }
}

//MARK: - search result
struct SearchResult: Codable {
    let id: Int
    let name: String
    let photos: [SearchResultPhoto]
}

