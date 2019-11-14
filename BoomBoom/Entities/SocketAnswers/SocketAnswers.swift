//
//  SocketAnswers.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: - Realm obects
class RealmChat:Object{
    dynamic var photos = List<RealmChatPhoto>()
    @objc dynamic var name = ""
    @objc dynamic var online = false
    @objc dynamic var accountID = -1
    @objc dynamic var lastDateAddMessage: Int64 = 0
    @objc dynamic var chatID = -1
    @objc dynamic var message: RealmMessage? = nil
    @objc dynamic var favorite = false
    @objc dynamic var countNewMessages = 0
    @objc dynamic var typeAccount = ""
}

class RealmChatPhoto: Object{
    @objc dynamic var pathURLPreview: String? = nil
}

class RealmMessage:Object{
    @objc dynamic var accountID = -1
    @objc dynamic var message = ""
    @objc dynamic var dateSend: Int64 = 0
    @objc dynamic var chatMessageID = -1
    @objc dynamic var chatID = -1
    @objc dynamic var typeMessage = ""
    dynamic var chatMessageStatusList = List<RealmChatMessageStatus>()
}

class RealmChatMessageStatus:Object{
    @objc dynamic var id = -1
    @objc dynamic var accountID = -1
    @objc dynamic var delivered = false
    @objc dynamic var read = false
}

// MARK: - SentPhotoAnswer when sending photo via REST
struct SentPhotoAnswer: Codable {
    let id: Int
    let pathURL, pathURLPreview: String
    let accountFrom, accountTo: Int

    enum CodingKeys: String, CodingKey {
        case id
        case pathURL = "pathUrl"
        case pathURLPreview = "pathUrlPreview"
        case accountFrom, accountTo
    }
}


//MARK: - Socket Answers

struct AuthResult: Codable {
    let accountID: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case status
    }
}

// MARK: - SendMessageAnswer
struct SendMessageAnswer: Codable {
    let accountID, companionID: Int
    let message: String
    let dateSend: Int64
    let chatMessageID, chatID: Int
    let chatMessageStatusList: [ChatMessageStatus]
    let typeMessage, accountName: String

    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case companionID = "companionId"
        case message, dateSend
        case chatMessageID = "chatMessageId"
        case chatID = "chatId"
        case chatMessageStatusList, typeMessage, accountName
    }
}

// MARK: - ChatMessageStatusList
struct ChatMessageStatus: Codable {
    let id, accontID: Int
    var delivered, read: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case accontID = "accontId"
        case delivered, read
    }
}

// MARK: - GetChatListAnswer
struct GetChatListAnswer: Codable {
    let countNewMessages, countAllChats: Int
    let chats: [Chat]
}

// MARK: - Chat
struct Chat: Codable {
    let photo: [ChatPhoto]?
    let name: String
    let online: Bool
    let accountID: Int
    let lastDateAddMessage: Int64?
    let chatID: Int
    let message: SocketMessage?
    let favorite: Bool
    let countNewMessages: Int?
    let typeAccount: String?

    enum CodingKeys: String, CodingKey {
        case photo, name, online
        case accountID = "accountId"
        case lastDateAddMessage
        case chatID = "chatId"
        case message, favorite, countNewMessages, typeAccount
    }
}

// MARK: - Message
struct SocketMessage: Codable {
    let accountID: Int
    let message: String
    let dateSend: Int64
    let chatMessageID, chatID: Int
    let chatMessageStatusList: [ChatMessageStatus]
    let typeMessage: String
    
    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case message, dateSend
        case chatMessageID = "chatMessageId"
        case chatID = "chatId"
        case chatMessageStatusList, typeMessage
        
    }
}

// MARK: - Photo
struct ChatPhoto: Codable {
    let pathURLPreview: String

    enum CodingKeys: String, CodingKey {
        case pathURLPreview = "pathUrlPreview"
    }
}
