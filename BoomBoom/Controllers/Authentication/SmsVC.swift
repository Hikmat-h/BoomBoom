//
//  SmsVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class SmsVC: UIViewController {

    @IBOutlet weak var smsField: UITextField!
    @IBOutlet weak var regBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smsField = Utils.current.setTextFieldStyle(smsField)
        regBtn = Utils.current.setButtonStyle(btn: regBtn)
    }
    
    @IBAction func onReg(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.NAME_SEGUE.SMS_TO_REG_DETAIL, sender: self)
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
