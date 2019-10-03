//
//  ProfileActionCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/1/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class ProfileActionCell: UITableViewCell {

    @IBOutlet weak var subscriptionBtn: UIButton!
    @IBOutlet weak var blanketBtn: UIButton!
    @IBOutlet weak var nameAndAgeLbl: UILabel!
    @IBOutlet weak var subscriptionDaysLeftLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blanketBtn = Utils.current.setButtonStyle(btn: blanketBtn, cornerRadius: 15)
        subscriptionBtn = Utils.current.setButtonStyle(btn: subscriptionBtn, cornerRadius: 15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
