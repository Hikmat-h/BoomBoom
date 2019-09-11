//
//  StarredChatsCollectionVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/12/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class StarredChatsCollectionVC: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.STARRED_CHATS_CELL, for: indexPath)
        return cell
    }
    

}
