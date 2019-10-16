//
//  UserProfilePhotosCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/1/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage
import PeekPop

class UserProfilePhotosCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var numOfPhotosLbl: UILabel!
    
    var userPhotos:[Photo] = []
    let baseURL = Constants.HTTP.PATH_URL
    var peekPop: PeekPop?
    var parentVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photosCollectionView.dataSource = self as UICollectionViewDataSource
        photosCollectionView.delegate = self as UICollectionViewDelegate
        
    }

    override func didMoveToSuperview() {
        //3d touch
        peekPop = PeekPop(viewController: parentVC!)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: photosCollectionView)
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
        if userPhotos.count == 0 {
            return 1
        }
        return userPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.PROFILE_PHOTO_CELL, for: indexPath) as! ProfilePhotosCell
        if indexPath.row == 0 && userPhotos.count == 0{
            cell.photoImgView.image = UIImage(named: "default_ava")
            cell.likeCountLbl.text = "0"
        } else {
            let photo = userPhotos[indexPath.row]
            let url = baseURL + "/" + photo.pathURLPreview
            cell.photoImgView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "transparent"), options: .refreshCached)
            cell.likeCountLbl.text = "\(photo.cntLike ?? 0)"
        }
        return cell
    }
}

extension UserProfilePhotosCell: PeekPopPreviewingDelegate {
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = photosCollectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = photosCollectionView?.cellForItem(at: indexPath) as? ProfilePhotosCell else { return nil }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let preview = storyboard.instantiateViewController(withIdentifier: "PreviewVC") as? PreviewVC else { return nil }
        previewingContext.sourceRect = cell.frame
        preview.img = cell.photoImgView.image
        
        return preview
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        
    }
    
    
}
