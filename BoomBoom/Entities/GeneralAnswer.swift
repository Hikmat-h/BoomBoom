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

struct AuthByMailNetworkResponseModel: Codable {
    let accessToken, tokenType: String
}

struct GenderModel: Codable {
    let id: Int
    let title: String
}

typealias GenderListAnswer = [GenderModel]

typealias CityListAnswerModel = [City]

typealias CountryListAnswerModel = [Country]



// MARK: - EditUserInfo
struct EditUserInfo: Codable {
    let id: Int
    let name, dateBirth: String
    let countries: Country
    let cities: City
    let information: String
    let sexualOrientation, bodyType, sex: BodyType
    let weight, height, breastSize: Int
    let pdSponsorship, pdSpendEvening, pdPeriodicMeetings, pdTravels: Bool
    let pdFriendshipCommunication: Bool
    let hobby, favoritePlacesCity, visitedCountries, countriesWantVisit: String
    let photos: [Photo]
    let email, phone: String
    let hairColor, verification: BodyType
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
    let main: Bool
    let cntLike: Int
    let ilike: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case pathURL = "pathUrl"
        case pathURLPreview = "pathUrlPreview"
        case main, cntLike, ilike
    }
}
