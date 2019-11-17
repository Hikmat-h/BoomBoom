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
import MobileCoreServices
import SDWebImage
import AVFoundation

class MessagingVC: MessagesViewController{

    var messages: [Message] = []
    let months: [String] = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    var partnersAccountID = -1
    var chatID = -1
    var chatMessageID = -1
    var partnersName = ""
    var userAccountID = UserDefaults.standard.value(forKey: "accountID") as? Int ?? 0
    var lastMessageDate = Int64()
    var messageAccountID = -1
    var newChat = false
    var partner: Sender?
    var user: Sender?
    var lastMessageStatusList: [ChatMessageStatus] = []
    var lastmessage = ""
    var lastMessageType = ""
    
    let token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    let baseURL = Constants.HTTP.PATH_URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        self.navigationItem.title = "ЧАТ"
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        let videoBtn = UIBarButtonItem(image: UIImage(named: "video"), style: .plain, target: self, action: #selector(onVideo))
        navigationItem.rightBarButtonItem = videoBtn
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
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
            if lastMessageType == "text" {
                let lastM = Message(text: lastmessage, messageId: "\(chatMessageID)", date: posixToDate(posixDate: lastMessageDate), sender: currentSender, statusList: lastMessageStatusList)
                messages.append(lastM)
            } else if lastMessageType == "photo" {
                let url = self.baseURL + "/" + lastmessage + "&type=preview"
                let lastM = Message(imageURL: url, messageId: "\(chatMessageID)", date: posixToDate(posixDate: lastMessageDate), sender: currentSender, statusList: lastMessageStatusList)
                messages.append(lastM)
            } else if lastMessageType == "video" {
                let url = self.baseURL + "/" + lastmessage
                let lastM = Message(thumbnailURL: url, messageId: "\(chatMessageID)", date: posixToDate(posixDate: lastMessageDate), sender: currentSender, statusList: lastMessageStatusList)
                messages.append(lastM)
            }
        }
        
        //to receive messages
        SocketManager.current.delegate = self
        SocketManager.current.getOldMessages(chatId: chatID, chatMessageId: chatMessageID)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    func getFilePath(withName:String)->String?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(withName).mp4") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return filePath
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getVideoThumbnail(url: String, completion: @escaping (UIImage?)->Void) {
        let headers = ["Authorization": "Bearer \(token)"]
        let asset = AVURLAsset(url: URL(fileURLWithPath: url), options: ["AVURLAssetHTTPHeaderFieldsKey":headers])
        var time = asset.duration
        time.value = min(time.value, 500)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        imgGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { (_, image, _, _, _) in
            if let image = image {
                completion(UIImage(cgImage: image))
            } else {
                completion(nil)
            }
        }
    }
    
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
        imagePicker.mediaTypes.append(kUTTypeMovie as String) //[kUTTypeMovie as String, kUTTypePNG as String, kUTTypeJPEG as String]
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
                                   string: "прочитано",
                                   attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: paragraph])
                } else if partnerStatus.delivered && !nextmessage!.delivered{
                    let paragraph = NSMutableParagraphStyle()
                                       paragraph.alignment = .right
                                       return NSAttributedString(
                                       string: "доставлено",
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
                    string: "прочитано",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: paragraph])
                } else if partnerStatus.delivered {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .right
                    return NSAttributedString(
                    string: "доставлено",
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
    
    func configureMediaMessageImageView(_ imageView: UIImageView,
                                        for message: MessageType,
                                        at indexPath: IndexPath,
                                        in messagesCollectionView: MessagesCollectionView) {
        guard
            let msg = message as? Message
        else { return }
        let temp = msg.url?.components(separatedBy: "&")
        if temp!.count>1 {
            //photo
            if let url = URL(string: msg.url ?? ""){
                imageView.viewWithTag(11)?.removeFromSuperview()
                imageView.viewWithTag(21)?.removeFromSuperview()
                imageView.sd_setImage(with: url, placeholderImage: nil)
            } else {
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.tag = 11
                blurEffectView.frame = imageView.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                imageView.addSubview(blurEffectView)
                
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.center = CGPoint(x:75, y:100)
                spinner.tag = 21
                imageView.addSubview(spinner)
                spinner.startAnimating()
            }
        } else {
            //video
            if URL(string: msg.url ?? "") != nil{
                imageView.viewWithTag(11)?.removeFromSuperview()
                imageView.viewWithTag(21)?.removeFromSuperview()
                let temp = msg.url?.components(separatedBy: "id=")
                if let path = getFilePath(withName: temp?[1] ?? "") {
                    getVideoThumbnail(url: path) { (image) in
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                } else {
                    imageView.image = UIImage()
                }
            } else {
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.tag = 11
                blurEffectView.frame = imageView.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                imageView.addSubview(blurEffectView)

                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.center = CGPoint(x:75, y:100)
                spinner.tag = 21
                imageView.addSubview(spinner)
                spinner.startAnimating()
            }
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
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

extension MessagingVC: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let index = messagesCollectionView.indexPath(for: cell) {
            let message = messages[index.section]
            if let url = message.url{
                let temp = url.components(separatedBy: "&")
                if temp.count>1{
                    //photo
                    let vc = storyboard?.instantiateViewController(withIdentifier: "ChatPhotoVC") as? ChatPhotoVC
                    vc?.url = temp[0] + "&type=general"
                    self.show(vc!, sender: self)
                } else {
                    //video
                    let vc = storyboard?.instantiateViewController(withIdentifier: "ChatPhotoVC") as? ChatPhotoVC
                    vc?.url = temp[0]
                    vc?.isVideo = true
                    self.show(vc!, sender: self)
                }
            }
        }
    }
}

//MARK: - socket delegates
extension MessagingVC: SocketManagerDelegate {
    func didReceiveMessage(detail: SendMessageAnswer) {
        //my message
        if detail.accountID == userAccountID {
            switch detail.typeMessage {
            case "text":
                let newMessage = Message(text: detail.message, messageId: "\(detail.chatMessageID)", date: posixToDate(posixDate: detail.dateSend), sender: user!, statusList: [ChatMessageStatus(id: chatID, accontID: userAccountID, delivered: true, read: true), ChatMessageStatus(id: chatID, accontID: partnersAccountID, delivered: false, read: false)])
                messages.append(newMessage)
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
            case "photo":
                let url = self.baseURL + "/" + detail.message + "&type=preview"
                let newMessage = Message(imageURL: url, messageId: "\(detail.chatMessageID)", date: posixToDate(posixDate: detail.dateSend), sender: user!, statusList: [ChatMessageStatus(id: chatID, accontID: userAccountID, delivered: true, read: true), ChatMessageStatus(id: chatID, accontID: partnersAccountID, delivered: false, read: false)])
                messages[messages.count-1] = newMessage
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
            case "video":
                let url = self.baseURL + "/" + detail.message
                let newMessage = Message(thumbnailURL: url, messageId: "\(detail.chatMessageID)", date: posixToDate(posixDate: detail.dateSend), sender: user!, statusList: [ChatMessageStatus(id: chatID, accontID: userAccountID, delivered: true, read: true), ChatMessageStatus(id: chatID, accontID: partnersAccountID, delivered: false, read: false)])
                messages[messages.count-1] = newMessage
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
                break
            default:
                return
            }
            //partner's message
        } else if detail.accountID == partnersAccountID {
            SocketManager.current.sendDeliveryStatus(chatMessageId: detail.chatMessageID)
            SocketManager.current.sendReadStatus(chatMessageId: detail.chatMessageID)
            switch detail.typeMessage {
            case "text":
                let newMessage = Message(text: detail.message, messageId: "\(detail.chatMessageID)", date: posixToDate(posixDate: detail.dateSend), sender: partner!, statusList: detail.chatMessageStatusList)
                messages.append(newMessage)
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
            case"photo":
                let url = self.baseURL + "/" + detail.message + "&type=preview"
                let newMessage = Message(imageURL: url, messageId: "\(detail.chatMessageID)", date: posixToDate(posixDate: detail.dateSend), sender: partner!, statusList: detail.chatMessageStatusList)
                messages.append(newMessage)
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
            case "video":
                let url = self.baseURL + "/"
                let newMessage = Message(thumbnailURL: url, messageId: "\(detail.chatMessageID)", date: posixToDate(posixDate: detail.dateSend), sender: partner!, statusList: detail.chatMessageStatusList)
                messages.append(newMessage)
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
                break
            default:
                return
            }
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
                switch mess.typeMessage {
                case "text":
                    let oldMess =  Message(text: mess.message, messageId: "\(mess.chatMessageID)", date: posixToDate(posixDate: mess.dateSend), sender: currentSender, statusList: mess.chatMessageStatusList)
                    self.messages.insert(oldMess, at: 0)
                case "photo":
                    let url = self.baseURL + "/" + mess.message + "&type=preview"
                    let oldMess = Message(imageURL: url, messageId: "\(mess.chatMessageID)", date: posixToDate(posixDate: mess.dateSend), sender: currentSender, statusList: mess.chatMessageStatusList)
                    self.messages.insert(oldMess, at: 0)
                case "video":
                    let url = self.baseURL + "/" + mess.message
                    let oldMess = Message(thumbnailURL: url, messageId: "\(mess.chatMessageID)", date: posixToDate(posixDate: mess.dateSend), sender: currentSender, statusList: mess.chatMessageStatusList)
                    self.messages.insert(oldMess, at: 0)
                    break
                default:
                    let url = self.baseURL + "/" + mess.message
                    let oldMess = Message(thumbnailURL: url, messageId: "\(mess.chatMessageID)", date: posixToDate(posixDate: mess.dateSend), sender: currentSender, statusList: mess.chatMessageStatusList)
                    self.messages.insert(oldMess, at: 0)
                }
            }
            SocketManager.current.getOldMessages(chatId: messages.last!.chatID, chatMessageId: messages.last!.chatMessageID)
        } else {
            //to avoid flickering
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
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
        let index = messages.firstIndex(where: {Int($0.messageId) == chatMessageID}) ?? messages.count-1
        let statusIndex = messages[index ].statusList.firstIndex(where: {$0.accontID == partnersAccountID})
        messages[index ].statusList[statusIndex ?? 0].read = true
        if (index > 0) {
            messagesCollectionView.reloadItems(at: [IndexPath(row: 0, section: (index - 1))])
        }
        messagesCollectionView.reloadItems(at: [IndexPath(row: 0, section: index )])
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

//MARK: - Photo picker extension
extension MessagingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString

        switch mediaType {
        case kUTTypeImage:
            guard let tempImg = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
            
            let image = UIImage(cgImage: tempImg.cgImage!, scale: tempImg.scale, orientation: .up)
            
            let newMessage = Message(imageURL: "", messageId: "", date: Date(), sender: self.user!, statusList: [ChatMessageStatus(id: self.chatID, accontID: self.userAccountID, delivered: true, read: true), ChatMessageStatus(id: self.chatID, accontID: self.partnersAccountID, delivered: false, read: false)])
            self.messages.append(newMessage)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
            
            ChatMediaManager.current.sendPhoto(token:token , lang: language, image: image, accountToId: partnersAccountID, name: "photo") { (model, error) in
                        if error != nil {
                            DispatchQueue.main.async {
                                self.showErrorWindow(errorMessage: error?.domain ?? "")
                            }
                        } else {
                            let temp = model?.pathURL.components(separatedBy: "&")
                            SocketManager.current.sendMessage(accountID: self.partnersAccountID, message: temp?[0] ?? "", typeMessage: "photo")
                        }
                    }
        case kUTTypeMovie:
            guard let videoPath = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {return}
            let newMessage = Message(thumbnailURL: videoPath.absoluteString, messageId: "", date: Date(), sender: self.user!, statusList: [ChatMessageStatus(id: self.chatID, accontID: self.userAccountID, delivered: true, read: true), ChatMessageStatus(id: self.chatID, accontID: self.partnersAccountID, delivered: false, read: false)])
            self.messages.append(newMessage)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
            do {
                let videoData = try Data(contentsOf: videoPath, options: .mappedIfSafe)
                ChatMediaManager.current.sendVideo(token: token, lang: language, videoData: videoData, accountToId: self.partnersAccountID, name: "video") { (model, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.showErrorWindow(errorMessage: error?.domain ?? "")
                        }
                    } else {
                        SocketManager.current.sendMessage(accountID: self.partnersAccountID, message: model?.pathURL ?? "", typeMessage: "video")
                    }
                }
            } catch{}
            
            break
        case kUTTypeLivePhoto:
            break
        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
