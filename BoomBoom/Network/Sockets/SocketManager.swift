//
//  Sockets.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Starscream
protocol SocketManagerDelegate: class{
    func didReceiveChatList(socketChats:GetChatListAnswer)
    func didReceiveMessage(detail:SendMessageAnswer)
    func didReceiveChatDetail(chatDetail:Chat)
    func didReceiveOldMessages(messages:[SocketMessage])
    func didReceiveChatInitAnswer(detail:Chat)
    func didReceiveMessageDelivery(accountID: Int, chatMessageID: Int, chatID: Int)
    func didReceiveMessageRead(accountID: Int, chatMessageID: Int, chatID: Int)
}

class SocketManager{
    
    static let current = SocketManager()
    var selfID = 0
    weak var delegate:SocketManagerDelegate?
    var retry = true
    public var ws = WebSocket(url: URL(string: Constants.Sockets.PATH)!)
    private init(){
        selfID = UserDefaults.standard.value(forKey: "accountID") as? Int ?? 0
    }
    
    func connect() {
        retry = true
        ws.delegate = self as WebSocketDelegate
        ws.connect()
    }
    
    func close() {
        retry = false
        ws.disconnect()
    }
}

extension SocketManager: WebSocketDelegate {
    //MARK: - web socket delegates
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
        let token = UserDefaults.standard.value(forKey: "token") ?? ""
        socket.write(string: "{\"action\":\"auth\", \"object\":{\"accessToken\":\"\(token)\"}}")
    }
   
   func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
        if retry {
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.ws.connect()
            }
        }
   }
    
    //MARK: - Socket request methods
    func sendMessage(accountID:Int, message:String, typeMessage:String) {
        let object: Dictionary<String, Any> = ["accountId":accountID, "message":message, "typeMessage":typeMessage]
        let dict: Dictionary<String, Any> = ["action":"sendmessage", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func sendDeliveryStatus(chatMessageId: Int) {
        let object: Dictionary<String, Any> = ["chatMessageId":chatMessageId]
        let dict: Dictionary<String, Any> = ["action":"delivery", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func sendReadStatus(chatMessageId: Int) {
        let object: Dictionary<String, Any> = ["chatMessageId":chatMessageId]
        let dict: Dictionary<String, Any> = ["action":"read", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func readAll(chatid: Int) {
        let object: Dictionary<String, Any> = ["chatid":chatid]
        let dict: Dictionary<String, Any> = ["action":"readall", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getChatListByPage(_ page:Int) {
        let object: Dictionary<String, Any> = ["page":page]
        let dict: Dictionary<String, Any> = ["action":"synchronizedall", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getChatDetail(chatID:Int) {
        let object: Dictionary<String, Any> = ["chatId":chatID]
        let dict: Dictionary<String, Any> = ["action":"chatdetail", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getOldMessages(chatId: Int, chatMessageId: Int) {
        let object: Dictionary<String, Any> = ["chatId":chatId, "chatMessageId":chatMessageId]
        let dict: Dictionary<String, Any> = ["action":"getoldmessages", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func initializeChats(accountId: Int) {
        let object: Dictionary<String, Any> = ["accountId":accountId]
        let dict: Dictionary<String, Any> = ["action":"chatinit", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteChat(chatId: Int) {
        let object: Dictionary<String, Any> = ["chatId":chatId]
        let dict: Dictionary<String, Any> = ["action":"deletechat", "object":object]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
            let str = String(decoding: data, as: UTF8.self)
            ws.write(string: str)
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: - built-in web socket delegates
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        var answerDict = Dictionary<String, AnyObject>()
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,AnyObject> {
            answerDict = jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        //take action
        switch answerDict["action"] as? String {
        case "auth":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(AuthResult.self, from: data)
                selfID = detail?.accountID ?? 0
                UserDefaults.standard.set(detail?.accountID, forKey: "accountID")
                getChatListByPage(0)
            } catch let error as NSError {
                print(error)
            }
        case "sendmessage":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(SendMessageAnswer.self, from: data)
                if detail?.accountID != selfID {
                    delegate?.didReceiveMessage(detail: detail!)
                }
            } catch let error as NSError {
                print(error)
            }
        case "synchronizedall":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(GetChatListAnswer.self, from: data)
                print(detail as Any)
                delegate?.didReceiveChatList(socketChats: detail ?? GetChatListAnswer(countNewMessages: 0, countAllChats: 0, chats: []))
            } catch let error as NSError {
                print(error)
            }
        case "chatdetail":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(Chat.self, from: data)
                if let d = detail {
                    delegate?.didReceiveChatDetail(chatDetail: d)
                }
            } catch let error as NSError {
                print(error)
            }
        case "getoldmessages":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode([SocketMessage].self, from: data)
                if let d = detail {
                    delegate?.didReceiveOldMessages(messages: d)
                }
            } catch let error as NSError {
                print(error)
            }
        case "chatinit":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(Chat.self, from: data)
                if let d = detail {
                    delegate?.didReceiveChatInitAnswer(detail: d)
                }
            } catch let error as NSError {
                print(error)
            }
        case "delivery":
            let accountID = (answerDict["result"]?.object(forKey: "accountId") ?? 0) as! Int
            let chatMessageID = (answerDict["result"]?.object(forKey: "chatMessageId") ?? 0) as! Int
            let chatID = (answerDict["result"]?.object(forKey: "chatId") ?? 0) as! Int
            if accountID != selfID {
                delegate?.didReceiveMessageDelivery(accountID: accountID, chatMessageID: chatMessageID, chatID: chatID)
            }
        case "read":
            let accountID = (answerDict["result"]?.object(forKey: "accountId") ?? 0) as! Int
            let chatMessageID = (answerDict["result"]?.object(forKey: "chatMessageId") ?? 0) as! Int
            let chatID = (answerDict["result"]?.object(forKey: "chatId") ?? 0) as! Int
            if accountID != selfID {
                delegate?.didReceiveMessageRead(accountID: accountID, chatMessageID: chatMessageID, chatID: chatID)
            }
        case nil:
            if let error = answerDict["error"] as? NSError {
                print(error.domain)
            }
        default:
            print(answerDict)
        }
   }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(String(decoding: data, as: UTF8.self))")
   }
    
}

extension SocketManagerDelegate {
    func didReceiveChatList(socketChats:GetChatListAnswer) {}
    func didReceiveMessage(detail:SendMessageAnswer) {}
    func didReceiveChatDetail(chatDetail:Chat) {}
    func didReceiveOldMessages(messages:[SocketMessage]) {}
    func didReceiveChatInitAnswer(detail:Chat) {}
    func didReceiveMessageDelivery(accountID: Int, chatMessageID: Int, chatID: Int) {}
    func didReceiveMessageRead(accountID: Int, chatMessageID: Int, chatID: Int) {}
}
