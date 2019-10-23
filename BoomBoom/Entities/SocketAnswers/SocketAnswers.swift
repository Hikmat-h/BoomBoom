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
    dynamic var name = ""
    dynamic var online = false
    dynamic var accountID = -1
    dynamic var lastDateAddMessage: CLong = -1
    dynamic var chatID = -1
    dynamic var message = RealmMessage()
    dynamic var favorite = false
    dynamic var countNewMessages = 0
    dynamic var typeAccount = ""
}

class RealmChatPhoto: Object{
    dynamic var pathURLPreview: String? = nil
}

class RealmMessage:Object{
    dynamic var accountID = -1
    dynamic var message = ""
    dynamic var dateSend: CLong = -1
    dynamic var chatMessageID = -1
    dynamic var chatID = -1
    dynamic var chatMessageStatusList = List<RealmChatMessageStatus>()
}

class RealmChatMessageStatus:Object{
    dynamic var id = -1
    dynamic var accountID = -1
    dynamic var delivered = false
    dynamic var read = false
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
    let dateSend, chatMessageID, chatID: Int
    let chatMessageStatusList: [ChatMessageStatusList]
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
struct ChatMessageStatusList: Codable {
    let id, accontID: Int
    let delivered, read: Bool

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
    let photo: [ChatPhoto]
    let name: String
    let online: Bool
    let accountID, lastDateAddMessage, chatID: Int
    let message: SocketMessage
    let favorite: Bool
    let countNewMessages: Int
    let typeAccount: String

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
    let dateSend, chatMessageID, chatID: Int
    let chatMessageStatusList: [ChatMessageStatusList]

    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case message, dateSend
        case chatMessageID = "chatMessageId"
        case chatID = "chatId"
        case chatMessageStatusList
    }
}

// MARK: - Photo
struct ChatPhoto: Codable {
    let pathURLPreview: String

    enum CodingKeys: String, CodingKey {
        case pathURLPreview = "pathUrlPreview"
    }
}
