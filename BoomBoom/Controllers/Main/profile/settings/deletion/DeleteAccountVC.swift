//
//  DeleteAccountVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class DeleteAccountVC: UIViewController {

    @IBOutlet weak var blockAccountBtn: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blockAccountBtn = Utils.current.setButtonStyle(btn: blockAccountBtn)
        deleteAccountBtn = Utils.current.setButtonStyle(btn: deleteAccountBtn)
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
