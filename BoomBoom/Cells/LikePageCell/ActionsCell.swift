//
//  ActionsCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/19/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class ActionsCell: UITableViewCell {

    @IBOutlet weak var presentBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let present = UIImage(named: "gift")?.withRenderingMode(.alwaysTemplate)
        let chat = UIImage(named: "chat")?.withRenderingMode(.alwaysTemplate)
        presentBtn.setImage(present, for: .normal)
        chatBtn.setImage(chat, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
    }
}
