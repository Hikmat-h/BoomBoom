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
    let baseURL = Constants.HTTP.PATH_URL
    
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
        searchBar?.setPlaceholderTextColor(color: #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1))
        
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
        navigationItem.titleView = searchBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        let starBtn = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(onStar))
        navigationItem.rightBarButtonItem = starBtn
        SocketManager.current.delegate = self
    }
    
    @objc func onStar() {
        print("star is clicked")
        let realm = try! Realm()
        let test = realm.objects(RealmChatPhoto.self)
        print(test as Any)
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
        print(Date(timeIntervalSince1970: TimeInterval(chat.lastDateAddMessage)))
        cell.timeLbl.text = String(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(chat.lastDateAddMessage)/1000)))
        if (chat.message?.chatMessageStatusList[0].read)! {
            cell.lastMessageLbl.text = chat.message?.message
        } else {
            cell.lastMessageLbl.text = "Новое сообщение"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = (storyboard?.instantiateViewController(withIdentifier: "MessagingVC") as? MessagingVC) else { return }
        vc.partnersAccountID = chats[indexPath.row].accountID
        vc.chatID = chats[indexPath.row].message?.chatID ?? 0
        vc.chatMessageID = chats[indexPath.row].message?.chatMessageID ?? 0
        vc.partnersName = chats[indexPath.row].name
        vc.userAccountID = chats[indexPath.row].message?.chatMessageStatusList[0].accountID ?? 0
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

}

//MARK: - Extensions
extension ChatVC: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}

extension ChatVC: SocketManagerDelegate {
    
    func didReceiveChatList(socketChats: GetChatListAnswer) {
        let chats = socketChats.chats
        let localChats = List<RealmChat>()
        for chat in chats {
            let localChat = RealmChat()
            
            if chat.photo.count>0 {
                let photo = RealmChatPhoto()
                photo.pathURLPreview = chat.photo[0].pathURLPreview
                localChat.photos.append(photo)
            }
            
            localChat.name = chat.name
            localChat.online = chat.online
            localChat.accountID = chat.accountID
            localChat.lastDateAddMessage = chat.lastDateAddMessage
            localChat.chatID = chat.chatID
            localChat.message = RealmMessage()
            localChat.message?.accountID = chat.message.accountID
            localChat.message?.chatID = chat.message.chatID
            localChat.message?.chatMessageID = Int(chat.message.chatMessageID)
            
            if chat.message.chatMessageStatusList.count>0{
                let status = RealmChatMessageStatus()
                status.id = chat.message.chatMessageStatusList[0].id
                status.accountID = chat.message.chatMessageStatusList[0].accontID
                status.read = chat.message.chatMessageStatusList[0].read
                status.delivered = chat.message.chatMessageStatusList[0].delivered
                localChat.message?.chatMessageStatusList.append(status)
            }
            
            localChat.message?.dateSend = (chat.message.dateSend)
            localChat.message?.message = chat.message.message
            localChat.countNewMessages = chat.countNewMessages
            localChat.favorite = chat.favorite
            localChat.typeAccount = chat.typeAccount
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
    }
    
    func didReceiveMessage(detail: SendMessageAnswer) {
        if let chat = chats.first(where: {$0.chatID == detail.chatID}) {
            let realm = try! Realm()
            try! realm.write {
                chat.countNewMessages = 1
                chat.lastDateAddMessage = detail.dateSend
                chat.message?.message = detail.message
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
        localChat.countNewMessages = chatDetail.countNewMessages
        localChat.favorite = chatDetail.favorite
        localChat.lastDateAddMessage = chatDetail.lastDateAddMessage
        localChat.message?.accountID = chatDetail.message.accountID
        localChat.message?.chatID = chatDetail.message.chatID
        localChat.message?.chatMessageID = chatDetail.message.chatMessageID
//        localChat.message?.chatMessageStatusList[0].accountID = chatDetail.message.chatMessageStatusList[0].accontID
//        localChat.message?.chatMessageStatusList[0].delivered = chatDetail.message.chatMessageStatusList[0].delivered
        localChat.message?.dateSend = chatDetail.message.dateSend
        localChat.message?.message = chatDetail.message.message
        localChat.name = chatDetail.name
        localChat.online = chatDetail.online
        if chatDetail.photo.count>0{
            let photo = RealmChatPhoto()
            photo.pathURLPreview = chatDetail.photo[0].pathURLPreview
            localChat.photos.append(photo)
        }
        localChat.typeAccount = chatDetail.typeAccount
        let realm = try! Realm()
        try! realm.write {
            chats.append(localChat)
        }
        tableView.reloadData()
    }
}
