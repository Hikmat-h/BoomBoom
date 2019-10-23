//
//  Sockets.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Starscream
protocol SocketManagerDelegate {
    func didReceiveChatList(socketChats:GetChatListAnswer)
}

class SocketManager{
    
    static let current = SocketManager()
    var delegate:SocketManagerDelegate?
    public var ws = WebSocket(url: URL(string: Constants.Sockets.PATH)!)
    private init(){}
    
    func connect() {
        ws.delegate = self as WebSocketDelegate
        ws.connect()
    }
    
    func close() {
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
        switch answerDict["action"] as! String {
        case "auth":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(AuthResult.self, from: data)
                UserDefaults.standard.set(detail?.accountID, forKey: "accountID")
            } catch let error as NSError {
                print(error)
            }
        case "sendmessage":
            do {
                let data = try JSONSerialization.data(withJSONObject: answerDict["result"] as Any, options: .fragmentsAllowed)
                let detail = try? JSONDecoder().decode(SendMessageAnswer.self, from: data)
                print(detail as Any)
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
