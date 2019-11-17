//
//  Message.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/17/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

internal struct Message: MessageType {
    let url: String?
    let text: String?
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
    let sender: SenderType
    var statusList: [ChatMessageStatus]
    
    private init(url: String?, text: String?, messageId:String, sentDate:Date, kind: MessageKind, sender:SenderType, statusList: [ChatMessageStatus]) {
        self.url = url
        self.text = text
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.sender = sender
        self.statusList = statusList
        
    }
    
    init(text:String, messageId:String, date:Date, sender:SenderType, statusList: [ChatMessageStatus]) {
        self.init(url: nil, text: text, messageId: messageId, sentDate: date, kind: .text(text), sender: sender, statusList: statusList)
    }
    
    init(imageURL: String, messageId: String, date: Date, sender: SenderType, statusList: [ChatMessageStatus]) {
        let mediaItem = ImageMediaItem(url: URL(string: imageURL))
        self.init(url: imageURL, text: nil, messageId: messageId, sentDate: date, kind: .photo(mediaItem), sender: sender, statusList: statusList)
    }
    
    init(thumbnailURL: String, messageId: String, date: Date, sender: SenderType, statusList: [ChatMessageStatus]) {
        let mediaItem = ImageMediaItem(url: URL(string: thumbnailURL))
        self.init(url: thumbnailURL, text: nil, messageId: messageId, sentDate: date, kind: .video(mediaItem), sender: sender, statusList: statusList)
    }
}

struct ImageMediaItem: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(url: URL?) {
       self.url = url
       self.placeholderImage = UIImage()
        self.size = CGSize(width: 150, height: 200)
   }
}
