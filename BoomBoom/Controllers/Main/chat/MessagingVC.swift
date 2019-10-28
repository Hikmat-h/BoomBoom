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
    var user: Member!
    var partner: Member!
    
    let months: [String] = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    var partnersAccountID = -1
    var chatID = -1
    var chatMessageID = -1
    var partnersName = ""
    var userAccountID = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        self.navigationItem.title = "ЧАТ"
        let videoBtn = UIBarButtonItem(image: UIImage(named: "video"), style: .plain, target: self, action: #selector(onVideo))
        navigationItem.rightBarButtonItem = videoBtn
        
        user = Member(name: "tempName", color: .blue)
        partner = Member(name: partnersName, color: .green)
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
        
        SocketManager.current.getOldMessages(chatId: chatID, chatMessageId: chatMessageID)
        
        //to receive messages
        SocketManager.current.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func onVideo() {
        print("wanna video call??")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        print(formatter.string(from: Date()))
        return NSAttributedString(
            
            string: formatter.string(from: Date()),
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
        return Sender(id: "\(userAccountID)", displayName: user.name)
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
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
        avatarView.isHidden = true
    }
    
}

extension MessagingVC: MessageInputBarDelegate {
    
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let newMessage = Message(
            member: user,
            text: text,
            messageId: UUID().uuidString)
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        SocketManager.current.sendMessage(accountID: partnersAccountID, message: text, typeMessage: "text")
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

extension MessagingVC: SocketManagerDelegate {
    func didReceiveMessage(detail: SendMessageAnswer) {
        let newMessage = Message(
            member: partner,
            text: detail.message,
            messageId: UUID().uuidString)
        
        messages.append(newMessage)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func didReceiveOldMessages(messages: [SocketMessage]) {
        for mess in messages {
            let oldMess = Message(
            member: partner, //mess.accountID == self.partnersAccountID ? partner :
            text: mess.message,
            messageId: UUID().uuidString)
            self.messages.insert(oldMess, at: 0)
        }
        messagesCollectionView.reloadData()
    }
}
