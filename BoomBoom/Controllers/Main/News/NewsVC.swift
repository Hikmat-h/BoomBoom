//
//  NewsVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class NewsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var starredCollectionV: UICollectionView!
    @IBOutlet weak var photoCollectionV: UICollectionView!
    let cellWidth = UIScreen.main.bounds.size.width/3
    override func viewDidLoad() {
        super.viewDidLoad()
        starredCollectionV.delegate = self
        starredCollectionV.dataSource = self
        photoCollectionV.delegate = self
        photoCollectionV.dataSource = self
        
        photoCollectionV.collectionViewLayout = MosaicLayout()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == starredCollectionV {
            return 5
        } else {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == starredCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.STARRED_NEWS_CELL, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.NEWS_PHOTO_CELL, for: indexPath) as! NewsPhotoCell
            if (indexPath.row == 0) {
                cell.photoImgView.frame.size = CGSize(width: cellWidth*2, height: cellWidth*2)
            } else {
                cell.photoImgView.frame.size = CGSize(width: cellWidth, height: cellWidth)
            }
            cell.backgroundColor = .red
            return cell
        }
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if (collectionView == photoCollectionV) {
//            let height = cellWidth+1
//            if (indexPath.row == 0) {
//                return CGSize(width: cellWidth*2, height: height*2)
//            }
//
//            return CGSize(width: cellWidth, height: height)
//        } else {
//            return CGSize(width: 81, height: 113)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
