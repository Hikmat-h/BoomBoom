//
//  UserProfilePhotosCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/1/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage

class UserProfilePhotosCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var numOfPhotosLbl: UILabel!
    
    var userPhotos:[Photo] = []
    let baseURL = Constants.HTTP.PATH_URL
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photosCollectionView.dataSource = self as UICollectionViewDataSource
        photosCollectionView.delegate = self as UICollectionViewDelegate
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Photos collectionView dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.PROFILE_PHOTO_CELL, for: indexPath) as! ProfilePhotosCell
        let photo = userPhotos[indexPath.row]
        let url = baseURL + "/" + photo.pathURLPreview
        cell.photoImgView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "transparent"), options: .refreshCached)
        cell.likeCountLbl.text = "\(photo.cntLike)"
        return cell
    }
}
