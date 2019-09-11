//
//  StarredChatsCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/12/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class StarredChatsCell: UICollectionViewCell {
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImgView.layer.cornerRadius = userImgView.frame.size.height/2
    }
    
}
