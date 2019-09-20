//
//  PreviewVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/17/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {

    @IBOutlet weak var previewImgV: UIImageView!
    var img: UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImgV.layer.cornerRadius = 8
        previewImgV.image = img
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
