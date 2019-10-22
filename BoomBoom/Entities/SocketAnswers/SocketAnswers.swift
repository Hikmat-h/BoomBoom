//
//  SocketAnswers.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation

struct AuthResult: Codable {
    let accountID: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case status
    }
}
