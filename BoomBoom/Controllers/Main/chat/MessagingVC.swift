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
import IQKeyboardManagerSwift

enum MessageStatus{
    case noStatus
    case read
    case delivered
}

class MessagingVC: MessagesViewController{

    var messages: [Message] = []
    var nextMessageStatus: MessageStatus = .noStatus
    let months: [String] = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    var partnersAccountID = -1
    var chatID = -1
    var chatMessageID = -1
    var lastmessage = ""
    var partnersName = ""
    var userAccountID = UserDefaults.standard.value(forKey: "accountID") as? Int ?? 0
    var lastMessageDate = Int64()
    var messageAccountID = -1
    var newChat = false
    var partner: Sender?
    var user: Sender?
    var lastMessageStatusList: [ChatMessageStatus] = []
    
    let token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        self.navigationItem.title = "ЧАТ"
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
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
            layout.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .zero))
            layout.attributedTextMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.incomingAvatarSize = .zero
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.videoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.videoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.locationMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.locationMessageSizeCalculator.incomingAvatarSize = .zero
            layout.emojiMessageSizeCalculator.incomingAvatarSize = .zero
            layout.emojiMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        configureMessageInputBar()
        
        //set values for both parties
        partner = Sender(id: "\(partnersAccountID)", displayName: partnersName)
        user = Sender(id: "\(userAccountID)", displayName: "Вы")
        
        var currentSender: Sender
        if messageAccountID == userAccountID {
            currentSender = user!
        } else {
            currentSender = partner!
        }
        
        if !newChat {
            let lastM = Message(text: lastmessage, messageId: "\(chatMessageID)", sentDate: posixToDate(posixDate: lastMessageDate), kind: .text(lastmessage), sender: currentSender, statusList: lastMessageStatusList)
            messages.append(lastM)
        }
        
        //to receive messages
        SocketManager.current.delegate = self
        SocketManager.current.getOldMessages(chatId: chatID, chatMessageId: chatMessageID)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardDidHideNotification, object: nil)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

//    @objc func keyboardWillShowNotification(notification: NSNotification) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
//
//    @objc func keyboardWillHideNotification(notification: NSNotification) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
    
    
    
    
    
    @objc func onVideo() {
        print("wanna video call??")
    }
    
    func posixToDate(posixDate: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval((posixDate)/1000))
    }
    
    func configureMessageInputBar(){
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(UIImage(named: "attach"), for: .normal)
        button.addTarget(self, action: #selector(onMedia), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        self.navigationController?.hidesBarsWhenKeyboardAppears = false
        messageInputBar.inputTextView.placeholder = "Ваше сообщение"
        messageInputBar.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.setTitle("", for: .normal)
        messageInputBar.sendButton.setTitle("", for: .highlighted)
        messageInputBar.sendButton.image = UIImage(named: "send")
        
    }
    
    @objc func onMedia() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

}

//MARK: - Message DataSource
extension MessagingVC: MessagesDataSource {
    
    //cell bottom label style
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if (Int(message.sender.senderId) == userAccountID) {
            let partnerStatusIndex =  messages[indexPath.section].statusList.firstIndex(where: {$0.accontID == partnersAccountID}) ?? 1
            let partnerStatus = messages[indexPath.section].statusList[partnerStatusIndex]
            var myNextMessageIndex:Int = -1
            //find my next messageIndex
            for index in stride(from: indexPath.section + 1, through: messages.count-1, by: 1) {
                if (Int(messages[index].sender.senderId) == userAccountID) {
                    myNextMessageIndex = index
                    break
                }
            }
            if myNextMessageIndex != -1{
                let nextmessage = messages[myNextMessageIndex].statusList.first(where: {$0.accontID == partnersAccountID})
                if partnerStatus.read && !nextmessage!.read {
                    let paragraph = NSMutableParagraphStyle()
                                   paragraph.alignment = .right
                                   return NSAttributedString(
                                   string: "read",
                                   attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: paragraph])
                } else if partnerStatus.delivered && !nextmessage!.delivered{
                    let paragraph = NSMutableParagraphStyle()
                                       paragraph.alignment = .right
                                       return NSAttributedString(
                                       string: "delivered",
                                       attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: paragraph])
                } else {
                    return nil
                }
            } else {
                //this should be last message
                if partnerStatus.read{
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .right
                    return NSAttributedString(
                    string: "read",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: paragraph])
                } else if partnerStatus.delivered {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .right
                    return NSAttributedString(
                    string: "delivered",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: paragraph])
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
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
        
        return 0
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        return nil
//        return NSAttributedString(
//            string: message.sender.displayName,
//            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

//MARK: - Message layout
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

//MARK: - Message displaying
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

//MARK: - MessageInputBar
extension MessagingVC: MessageInputBarDelegate {
    
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let textMess = text.trimmingCharacters(in: .whitespacesAndNewlines)
        inputBar.inputTextView.text = ""
        SocketManager.current.sendMessage(accountID: partnersAccountID, message: textMess, typeMessage: "text")
    }
}

//MARK: - socket delegates
extension MessagingVC: SocketManagerDelegate {
    func didReceiveMessage(detail: SendMessageAnswer) {
        if detail.accountID == userAccountID {
            let newMessage = Message(
                text: detail.message,
                messageId: "\(detail.chatMessageID)", sentDate: posixToDate(posixDate: detail.dateSend), kind: .text(detail.message), sender: user!, statusList: [ChatMessageStatus(id: chatID, accontID: userAccountID, delivered: true, read: true), ChatMessageStatus(id: chatID, accontID: partnersAccountID, delivered: false, read: false)] )
            messages.append(newMessage)
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        } else {
            SocketManager.current.sendDeliveryStatus(chatMessageId: detail.chatMessageID)
            SocketManager.current.sendReadStatus(chatMessageId: detail.chatMessageID)
            let newMessage = Message(
                text: detail.message,
                messageId: "\(detail.chatMessageID)", sentDate: posixToDate(posixDate: detail.dateSend), kind: .text(detail.message), sender: partner!, statusList: detail.chatMessageStatusList)
            
            messages.append(newMessage)
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func didReceiveOldMessages(messages: [SocketMessage]) {
        if messages.count>0 {
            for mess in messages {
                var currentSender:Sender
                if mess.accountID == userAccountID {
                    currentSender = user!
                } else {
                    currentSender = partner!
                }
                let oldMess = Message(
                text: mess.message,
                messageId: "\(mess.chatMessageID)", sentDate: posixToDate(posixDate: Int64(mess.dateSend)), kind: .text(mess.message), sender: currentSender, statusList: mess.chatMessageStatusList)
                self.messages.insert(oldMess, at: 0)
            }
            SocketManager.current.getOldMessages(chatId: messages.last!.chatID, chatMessageId: messages.last!.chatMessageID)
        } else {
            //to avoid flickering
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: false)
            SocketManager.current.readAll(chatid: chatID)
        }
    }
    
    func didReceiveMessageDelivery(accountID: Int, chatMessageID: Int, chatID: Int) {
        let index = messages.firstIndex(where: {Int($0.messageId) == chatMessageID}) ?? messages.count-1
        let statusIndex = messages[index].statusList.firstIndex(where: {$0.accontID == partnersAccountID})
        messages[index].statusList[statusIndex ?? 0].delivered = true
        if index > 0 {
            messagesCollectionView.reloadItems(at: [IndexPath(row: 0, section: (index - 1))])
        }
        messagesCollectionView.reloadItems(at: [IndexPath(row: 0, section: index)])
    }
    
    func didReceiveMessageRead(accountID: Int, chatMessageID: Int, chatID: Int) {
        let index = messages.firstIndex(where: {Int($0.messageId) == chatMessageID})
        let statusIndex = messages[index ?? (messages.count-1)].statusList.firstIndex(where: {$0.accontID == partnersAccountID})
        messages[index ?? (messages.count-1)].statusList[statusIndex ?? 0].read = true
        messagesCollectionView.reloadItems(at: [IndexPath(row: 0, section: index ?? messages.count-1)])
    }
    
    func didReceiveMessageReadAll(accountID: Int, chatID: Int) {
        for index in stride(from: messages.count-1, through: 0, by: -1){
            let statusIndex = messages[index].statusList.firstIndex(where: {$0.accontID == partnersAccountID}) ?? 0
            if !messages[index].statusList[statusIndex].read {
                messages[index].statusList[statusIndex].read = true
            } else {
                messagesCollectionView.reloadData()
                break
            }
        }
    }
}

//MARK: - Photo editor extension
extension MessagingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        ChatMediaManager.current.sendPhoto(token:token , lang: language, image: image, accountToId: partnersAccountID, name: "photo") { (model, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            } else {
//                let newMessage = Message(text: model!.pathURL, messageId: "\(model?.id)", sentDate: Date(), kind: .photo(ImageMediaItem), sender: self.user!, statusList: [ChatMessageStatus(id: self.chatID, accontID: self.userAccountID, delivered: true, read: true), ChatMessageStatus(id: self.chatID, accontID: self.partnersAccountID, delivered: false, read: false)])
//
//                self.messages.append(newMessage)
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
