//
//  ChatPhotoVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 11/13/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage
class ChatPhotoVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.sd_setImage(with: URL(string: url), completed: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
