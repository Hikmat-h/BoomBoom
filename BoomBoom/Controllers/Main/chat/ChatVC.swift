//
//  ChatVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var vc:StarredChatsCollectionVC?
    lazy var searchBar: UISearchBar? = nil
    private var searchController: UISearchController!
    
    var chats = List<RealmChat>()
    var topPaidList = NewAccountListAnswer()
    
    let baseURL = Constants.HTTP.PATH_URL
    let token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    var userAccountID = 0
    let screenWidth = UIScreen.main.bounds.width
    //to load more chats
    var pageNo:CLong=0
    var isLastPage:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        
        vc = StarredChatsCollectionVC()
        collectionView.dataSource = vc
        collectionView.delegate = vc

        //search bar
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.backgroundColor = .clear
        searchBar?.placeholder = "Поиск"
        searchBar?.barTintColor = .clear
        searchBar?.tintColor = .clear
        searchBar?.setTextFieldColor(color: .clear)
        searchBar?.setTextColor(color: .white)
        searchBar?.setPlaceholderTextColor(color: .red)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.getTop(token: token, lang: language)
//        searchController.title = "Поиск"
//        if #available(iOS 11.0, *) {
//            searchController.delegate = self
//            searchController.obscuresBackgroundDuringPresentation = false
//            searchController.searchBar.placeholder = "Поиск"
//            searchController.searchBar.delegate = self
//            definesPresentationContext = true
//
//            searchController.hidesNavigationBarDuringPresentation = true
//            navigationItem.hidesSearchBarWhenScrolling = false
//            searchController.searchBar.heightAnchor.constraint(equalToConstant: 56).isActive = true
//            navigationItem.searchController = searchController
//        } else {
//            navigationItem.titleView = searchBar
//            // Fallback on earlier versions
//        }
//        navigationItem.titleView = searchBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        let starBtn = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(onStar))
        navigationItem.rightBarButtonItem = starBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SocketManager.current.delegate = self
        pageNo = 0
        SocketManager.current.getChatListByPage(0)
    }
    
    @objc func onStar() {
        print("star is clicked")
    }
    @objc func viewTapped() {
        searchBar?.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.NAME_CELL.CHAT_LIST_CELL) as! ChatListCell
        let chat = chats[indexPath.row]
        cell.nameLbl.text = chat.name
        if chat.online {
            cell.onlineImg.isHidden = false
        } else {
            cell.onlineImg.isHidden = true
        }
        if chat.favorite {
            cell.starImgView.image = UIImage(named: "star_filled")
        } else {
            cell.starImgView.image = UIImage(named: "star")
        }
        if chat.photos.count>0{
            let url = baseURL + "/" + (chat.photos[0].pathURLPreview ?? "")
            cell.userImgView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
        } else {
            cell.userImgView.image = UIImage(named: "default_ava")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.timeLbl.text = String(formatter.string(from: Date(timeIntervalSince1970: TimeInterval((chat.lastDateAddMessage)/1000))))
        if ((chat.message?.chatMessageStatusList.first(where: {$0.accountID == userAccountID})?.read ?? true)) && chat.message?.typeMessage == "text" {
            cell.lastMessageLbl.isHidden = false
            cell.photoMsg.isHidden = true
            cell.lastMessageLbl.text = chat.message?.message
        } else if chat.message?.typeMessage == "photo" {
            cell.lastMessageLbl.isHidden = true
            cell.photoMsg.image = UIImage(named: "picture")
            cell.photoMsg.isHidden = false
        } else if chat.message?.typeMessage == "video"{
            cell.lastMessageLbl.isHidden = true
            cell.photoMsg.image = UIImage(named: "video")
            cell.photoMsg.isHidden = false
        } else {
            cell.lastMessageLbl.isHidden = false
            cell.photoMsg.isHidden = true
            cell.lastMessageLbl.text = "Новое сообщение"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = (storyboard?.instantiateViewController(withIdentifier: "MessagingVC") as? MessagingVC) else { return }
        vc.newChat = false
        vc.chatID = chats[indexPath.row].message?.chatID ?? 0
        vc.chatMessageID = chats[indexPath.row].message?.chatMessageID ?? 0
        vc.partnersName = chats[indexPath.row].name
        vc.partnersAccountID = chats[indexPath.row].accountID
        vc.messageAccountID = chats[indexPath.row].message?.accountID ?? 0
        vc.lastmessage = chats[indexPath.row].message?.message ?? ""
        vc.lastMessageType = chats[indexPath.row].message?.typeMessage ?? ""
        vc.lastMessageDate = chats[indexPath.row].message?.dateSend ?? 0
        let status1 = chats[indexPath.row].message?.chatMessageStatusList[0]
        let status2 = chats[indexPath.row].message?.chatMessageStatusList[1]
        vc.lastMessageStatusList = [ChatMessageStatus(
            id: status1!.id,
            accontID: status1!.accountID,
            delivered: status1!.delivered,
            read: status1!.read),
                                    ChatMessageStatus(id: status2!.id,
                                                      accontID: status2!.accountID,
                                                      delivered: status2!.delivered,
                                                      read: status2!.read)]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //load more chats
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == chats.count-1 {
            if !isLastPage{
                pageNo = pageNo + 1
                SocketManager.current.getChatListByPage(pageNo)
            }
        }
    }
    
    //delete cells
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            SocketManager.current.deleteChat(chatId: chats[indexPath.row].chatID)
            let realm = try! Realm()
            try! realm.write {
                realm.delete(chats[indexPath.row])
            }
            tableView.beginUpdates()
            chats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        if (editingStyle == .insert) {
            
        }
    }

    func getTop(token:String, lang:String){
        NewsService.current.getTopPaid(token: token, lang: lang) { (accountsList, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.topPaidList = accountsList ?? []
                    self.collectionView.reloadData()
                } else if error?.code == 401 {
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                   // self.performSegue(withIdentifier: "showAuth", sender: self)
                    self.setNewRootController(nameController: "AuthorizationVC")
                } else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }
}

//MARK: - Extensions
extension ChatVC: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/5, height: 120.0)
    }
}

extension ChatVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topPaidList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starredChatsCell", for: indexPath) as! StarredChatsCell
        let acc = topPaidList[indexPath.row]
        if acc.online {
            cell.onlineImg.isHidden = false
        } else {
            cell.onlineImg.isHidden = true
        }
        cell.placeLbl.text = topPaidList[indexPath.row].cities.title
        cell.dateLbl.text = "\(topPaidList[indexPath.row].name), \(Utils.current.comuteAge(topPaidList[indexPath.row].dateBirth ))"
        if (topPaidList[indexPath.row].photos.count>0){
            let url = baseURL + "/" + topPaidList[indexPath.row].photos[0].pathURLPreview
            cell.userImgView?.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
        } else {
            cell.userImgView?.image = UIImage(named: "default_ava")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userAccountID != topPaidList[indexPath.row].id {
            SocketManager.current.initializeChats(accountId: topPaidList[indexPath.row].id)
        }
    }
}

extension ChatVC: SocketManagerDelegate {
    
    func didReceiveChatInitAnswer(detail: Chat) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = (storyboard.instantiateViewController(withIdentifier: "MessagingVC") as? MessagingVC) else { return }
        if let message = detail.message {
            vc.newChat = false
            vc.chatID = message.chatID
            vc.chatMessageID = message.chatMessageID
            vc.messageAccountID = message.accountID
            vc.lastmessage = message.message
            vc.lastMessageType = message.typeMessage
            vc.lastMessageDate = Int64(message.dateSend)
            let status1 = message.chatMessageStatusList[0]
            let status2 = message.chatMessageStatusList[1]
            vc.lastMessageStatusList = [status1, status2]
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        } else {
            vc.newChat = true
        }
        vc.partnersName = detail.name
        vc.partnersAccountID = detail.accountID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didReceiveChatList(socketChats: GetChatListAnswer) {
        userAccountID = UserDefaults.standard.value(forKey: "accountID") as? Int ?? 0
        let chats = socketChats.chats
        let localChats = List<RealmChat>()
        for chat in chats {
            let localChat = RealmChat()
            
            if chat.photo?.count ?? 0>0 {
                let photo = RealmChatPhoto()
                photo.pathURLPreview = chat.photo![0].pathURLPreview
                localChat.photos.append(photo)
            }
            
            localChat.name = chat.name
            localChat.online = chat.online
            localChat.accountID = chat.accountID
            localChat.lastDateAddMessage = Int64(chat.lastDateAddMessage!)
            localChat.chatID = chat.chatID
            localChat.message = RealmMessage()
            localChat.message?.accountID = chat.message!.accountID
            localChat.message?.chatID = chat.message!.chatID
            localChat.message?.chatMessageID = Int(chat.message!.chatMessageID)
            
            if (chat.message!.chatMessageStatusList.count)>0{
                let status = RealmChatMessageStatus()
                status.id = (chat.message!.chatMessageStatusList[0].id)
                status.accountID = (chat.message!.chatMessageStatusList[0].accontID)
                status.read = chat.message!.chatMessageStatusList[0].read
                status.delivered = chat.message!.chatMessageStatusList[0].delivered
                localChat.message?.chatMessageStatusList.append(status)
                
                let status1 = RealmChatMessageStatus()
                status1.id = (chat.message!.chatMessageStatusList[1].id)
                status1.accountID = (chat.message!.chatMessageStatusList[1].accontID)
                status1.read = chat.message!.chatMessageStatusList[1].read
                status1.delivered = chat.message!.chatMessageStatusList[1].delivered
                localChat.message?.chatMessageStatusList.append(status1)
            }
            
            localChat.message?.dateSend = Int64(chat.message!.dateSend)
            localChat.message?.message = chat.message!.message
            localChat.message?.typeMessage = chat.message!.typeMessage
            localChat.countNewMessages = chat.countNewMessages!
            localChat.favorite = chat.favorite
            localChat.typeAccount = chat.typeAccount!
            localChats.append(localChat)
        }
        if chats.count>0{
            self.chats = localChats
            self.isLastPage = false
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
                realm.add(localChats)
            }
        } else {
            self.isLastPage = true
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func didReceiveMessage(detail: SendMessageAnswer) {
        SocketManager.current.sendDeliveryStatus(chatMessageId: detail.chatMessageID)
        if let chat = chats.first(where: {$0.chatID == detail.chatID}) {
            let realm = try! Realm()
            try! realm.write {
                chat.countNewMessages = 1
                chat.lastDateAddMessage = detail.dateSend
                chat.message?.message = detail.message
                chat.message?.typeMessage = detail.typeMessage
                chat.message?.chatMessageStatusList[0].read = detail.chatMessageStatusList[0].read
                chat.message?.chatMessageStatusList[0].delivered = detail.chatMessageStatusList[0].delivered
            }
            tableView.reloadData()
        } else {
            SocketManager.current.getChatDetail(chatID: detail.chatID)
        }
    }
    
    func didReceiveChatDetail(chatDetail: Chat) {
        let localChat = RealmChat()
        localChat.accountID = chatDetail.accountID
        localChat.chatID = chatDetail.chatID
        localChat.countNewMessages = chatDetail.countNewMessages ?? 0
        localChat.favorite = chatDetail.favorite
        localChat.lastDateAddMessage = chatDetail.lastDateAddMessage ?? 0
        localChat.message = RealmMessage()
        localChat.message?.accountID = chatDetail.message!.accountID
        localChat.message?.chatID = chatDetail.message!.chatID
        localChat.message?.chatMessageID = chatDetail.message!.chatMessageID
        localChat.message?.typeMessage = chatDetail.message!.typeMessage

        localChat.message?.chatMessageStatusList.append(RealmChatMessageStatus())
        localChat.message?.chatMessageStatusList.append(RealmChatMessageStatus())
        localChat.message?.chatMessageStatusList[0].accountID = chatDetail.message!.chatMessageStatusList[0].accontID
        localChat.message?.chatMessageStatusList[0].delivered = chatDetail.message!.chatMessageStatusList[0].delivered
        localChat.message?.chatMessageStatusList[0].read = chatDetail.message!.chatMessageStatusList[0].read
        localChat.message?.chatMessageStatusList[0].id = chatDetail.message!.chatMessageStatusList[0].id
        
        localChat.message?.chatMessageStatusList[1].accountID = chatDetail.message!.chatMessageStatusList[1].accontID
        localChat.message?.chatMessageStatusList[1].delivered = chatDetail.message!.chatMessageStatusList[1].delivered
        localChat.message?.chatMessageStatusList[1].read = chatDetail.message!.chatMessageStatusList[1].read
        localChat.message?.chatMessageStatusList[1].id = chatDetail.message!.chatMessageStatusList[1].id
        
        localChat.message?.dateSend = Int64(chatDetail.message!.dateSend)
        localChat.message?.message = chatDetail.message!.message
        localChat.name = chatDetail.name
        localChat.online = chatDetail.online
        if chatDetail.photo?.count ?? 0>0{
            let photo = RealmChatPhoto()
            photo.pathURLPreview = chatDetail.photo![0].pathURLPreview
            localChat.photos.append(photo)
        }
        localChat.typeAccount = chatDetail.typeAccount ?? "undefined"
        let realm = try! Realm()
        try! realm.write {
            chats.append(localChat)
        }
        tableView.reloadData()
    }
}
