//
//  Sockets.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Starscream

class Socketmanager{
    
    static let current = Socketmanager()
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

extension Socketmanager: WebSocketDelegate {
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
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        var answer = Dictionary<String, Any>()
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
            answer = jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
//        switch answer["action"] as! String {
//        case "auth":
//            let test = try? JSONDecoder().decode(AuthResult.self, from:((answer["result"] as? Dictionary<String, Any>)?.data(using: .utf8))!)
//            print(test?.accountID as Any)
//        default:
//            print(answer)
//        }
   }
   
   func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(String(decoding: data, as: UTF8.self))")
   }
}
