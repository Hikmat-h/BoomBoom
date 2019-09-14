//
//  NewsPhotoCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/12/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class NewsPhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImgView: UIImageView!
    
    override func prepareForReuse() {
        //photoImgView.frame.size = CGSize (width: 125, height: 125)
    }
}
