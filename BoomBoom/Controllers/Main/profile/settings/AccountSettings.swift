//
//  AccountSettings.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class AccountSettings: UIViewController {

    @IBOutlet weak var blockAccountView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Вы уверены, что хотите выйти из аккаунта?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: {
            (action) in
            self.navigationController?.popToRootViewController(animated: true)
            }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
