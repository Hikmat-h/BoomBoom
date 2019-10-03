//
//  ProfileInfoCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/1/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    @IBOutlet weak var infoTitleLbl: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
