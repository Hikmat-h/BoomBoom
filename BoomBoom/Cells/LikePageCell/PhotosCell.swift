//
//  PhotosCellTableViewCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/19/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class PhotosCell: UITableViewCell {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let like = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        likeBtn.tintColor = #colorLiteral(red: 0.2745098039, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        likeBtn.setImage(like, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLike(_ sender: Any) {
        let gray = #colorLiteral(red: 0.2745098039, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        let red = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
        if (likeBtn.tintColor == gray) {
            likeBtn.tintColor = red
        } else {
            likeBtn.tintColor = gray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
}
