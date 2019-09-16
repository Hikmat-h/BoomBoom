//
//  ChatVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var vc:StarredChatsCollectionVC?
    lazy var searchBar: UISearchBar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        navigationItem.titleView = searchBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        let starBtn = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(onStar))
        navigationItem.rightBarButtonItem = starBtn
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.NAME_CELL.CHAT_LIST_CELL)!
        return cell
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
