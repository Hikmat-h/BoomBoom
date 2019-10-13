//
//  NewsVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import PeekPop

class NewsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, PeekPopPreviewingDelegate {
    
    var peekPop: PeekPop?
    
    @IBOutlet weak var starredCollectionV: UICollectionView!
    @IBOutlet weak var photoCollectionV: UICollectionView!
    let cellWidth = UIScreen.main.bounds.size.width/3
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        starredCollectionV.delegate = self
        starredCollectionV.dataSource = self
        photoCollectionV.delegate = self
        photoCollectionV.dataSource = self
        
        photoCollectionV.collectionViewLayout = MosaicLayout()
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: photoCollectionV)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //collectionView delegate
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
                cell.photoImgView.frame.size = CGSize(width: cellWidth*2 + 1, height: cellWidth*2 + 1)
            } else {
                cell.photoImgView.frame.size = CGSize(width: cellWidth + 1, height: cellWidth + 1)
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "LikePhotoVC") as? LikePhotoVC else { return }
            show(detailVC, sender: self)
        }
    }
    
    //for starred CollectionVeiw
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == starredCollectionV {
            return CGSize(width: screenWidth/5, height: 120.0)
        } else {
            return (collectionView.cellForItem(at: indexPath)?.frame.size)!
        }
    }
    
    
    //MARK: - 3d Touch
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = photoCollectionV?.indexPathForItem(at: location) else { return nil }
        if indexPath == IndexPath(item: 0, section: 0) {
            return nil
        }
        guard let cell = photoCollectionV?.cellForItem(at: indexPath) as? NewsPhotoCell else { return nil }
        guard let preview = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as? PreviewVC else { return nil }
        previewingContext.sourceRect = cell.frame
        preview.img = cell.photoImgView.image
        
        return preview
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
         guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "LikePhotoVC") as? LikePhotoVC else { return }
        show(detailVC, sender: self)
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
}
