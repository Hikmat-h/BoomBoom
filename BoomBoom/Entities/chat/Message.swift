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
    let text: String
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
    let sender: SenderType
    let statusList: [ChatMessageStatus]
}
