//
//  DeletionReasonVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/23/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class DeletionReasonVC: UIViewController {

    @IBOutlet weak var deleteAndSendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         deleteAndSendBtn = Utils.current.setButtonStyle(btn: deleteAndSendBtn)
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
