//
//  MessagingVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/17/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessagingVC: MessagesViewController{

    var messages: [Message] = []
    
    let months: [String] = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    var partnersAccountID = -1
    var chatID = -1
    var chatMessageID = -1
    var lastmessage = ""
    var partnersName = ""
    var userAccountID = -1
    var lastMessageDate = Int64()
    var messageAccountID = -1
    
    var partner: Sender?
    var user: Sender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        self.navigationItem.title = "ЧАТ"
        let videoBtn = UIBarButtonItem(image: UIImage(named: "video"), style: .plain, target: self, action: #selector(onVideo))
        navigationItem.rightBarButtonItem = videoBtn
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        MessageCollectionViewCell.appearance().backgroundColor = .black
        messagesCollectionView.backgroundColor = .black
        
        //remove space avatarView occupies
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }
        configureMessageInputBar()
        
        //set values
        partner = Sender(id: "\(partnersAccountID)", displayName: partnersName)
        user = Sender(id: "\(userAccountID)", displayName: "Вы")
        
        var currentSender: Sender
        if messageAccountID == userAccountID {
            currentSender = user!
        } else {
            currentSender = partner!
        }
        
        let lastM = Message(text: lastmessage, messageId: "\(chatMessageID)", sentDate: posixToDate(posixDate: lastMessageDate), kind: .text(lastmessage), sender: currentSender)
        messages.append(lastM)
        
        SocketManager.current.getOldMessages(chatId: chatID, chatMessageId: chatMessageID)
        
        //to receive messages
        SocketManager.current.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func onVideo() {
        print("wanna video call??")
    }
    
    func posixToDate(posixDate: Int64) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval((posixDate)/1000))
        return Date(timeIntervalSince1970: TimeInterval((posixDate)/1000))
    }
    
    func configureMessageInputBar(){
//        messageInputBar.rightStackViewItems = [InputItem]
        messageInputBar.inputTextView.placeholder = "Ваше сообщение"
        messageInputBar.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.setTitle("", for: .normal)
        messageInputBar.sendButton.setTitle("", for: .highlighted)
        messageInputBar.sendButton.image = UIImage(named: "send")
        
    }
    
    @objc func onMedia() {
        print("wanna choose file??")
    }

}

extension MessagingVC: MessagesDataSource {
    
    //cell bottom label style
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            
            string: "Прочитано",
            attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
    
    //cell top label style
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return NSAttributedString(
            
            string: formatter.string(from:messages[indexPath.section].sentDate),
            attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        return LabelAlignment(textAlignment: .natural, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    //-----
    
    func currentSender() -> SenderType {
        return user!
    }
    
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension MessagingVC: MessagesLayoutDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1)
    }
    
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
    }
}

extension MessagingVC: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        avatarView.backgroundColor = .white
        avatarView.isHidden = true
    }
    
}

extension MessagingVC: MessageInputBarDelegate {
    
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let newMessage = Message(
            text: text,
            messageId: "0", sentDate: Date(), kind: .text(text), sender: user!)
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        SocketManager.current.sendMessage(accountID: partnersAccountID, message: text, typeMessage: "text")
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

//MARK: - socket delegates
extension MessagingVC: SocketManagerDelegate {
    func didReceiveMessage(detail: SendMessageAnswer) {
        let newMessage = Message(
            text: detail.message,
            messageId: "\(detail.chatMessageID)", sentDate: posixToDate(posixDate: detail.dateSend), kind: .text(detail.message), sender: partner!)
        
        messages.append(newMessage)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func didReceiveOldMessages(messages: [SocketMessage]) {
        for mess in messages {
            var currentSender:Sender
            if mess.accountID == userAccountID {
                currentSender = user!
            } else {
                currentSender = partner!
            }
            let oldMess = Message(
            text: mess.message,
            messageId: "\(mess.chatMessageID)", sentDate: posixToDate(posixDate: mess.dateSend), kind: .text(mess.message), sender: currentSender)
            self.messages.insert(oldMess, at: 0)
        }
        messagesCollectionView.reloadData()
    }
}
