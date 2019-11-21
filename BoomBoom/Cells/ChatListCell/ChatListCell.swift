//
//  SearchCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var starImgView: UIImageView!
    @IBOutlet weak var photoMsg: UIImageView!
    @IBOutlet weak var onlineImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImgView.layer.cornerRadius = userImgView.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
