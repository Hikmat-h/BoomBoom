//
//  StarredNewsCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/12/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class StarredNewsCell: UICollectionViewCell {
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    
    override func awakeFromNib() {
        userImgView.layer.cornerRadius = userImgView.frame.size.height/2
        userImgView.layer.borderColor = UIColor.white.cgColor
        userImgView.layer.borderWidth = 2
    }
}
