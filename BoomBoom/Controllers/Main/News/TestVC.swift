//
//  TestVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/16/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
    
    @IBOutlet weak var imageV: UIImageView!
    var image: UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageV.image = image
        // Do any additional setup after loading the view.
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
