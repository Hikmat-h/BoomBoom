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

struct Message: MessageType {
    let url: String?
    let text: String?
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
    let sender: SenderType
    var statusList: [ChatMessageStatus]
}

struct PhotoMessage: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date

    var kind: MessageKind
}

struct MessageKindOf: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
}
