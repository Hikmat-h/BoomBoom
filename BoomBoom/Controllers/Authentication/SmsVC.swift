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
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    var code: String?
    var isReg: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smsField = Utils.current.setTextFieldStyle(smsField)
        regBtn = Utils.current.setButtonStyle(btn: regBtn)
        if ((code) != nil){
            smsField.text = code
        }
        
        
    }
    
    @IBAction func onReg(_ sender: Any) {
        guard let phone = UserDefaults.standard.value(forKey: "mobilePhone") as? String else { return }
        if (!(smsField.text?.isEmpty ?? true)) {
            sendCode(phone: phone, code: smsField.text ?? "")
        }
    }

    func sendCode (phone: String, code: String) {
       showActivityIndicator(loadingView: loadingView, spinner: spinner)
        AuthorizationService.current.authorizationBySmsCode(phone: phone, code: code) { (responseModel, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                guard let res = responseModel else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                    return
                }
                UserDefaults.standard.set(res.accessToken, forKey: "token")
                if self.isReg {
                    self.performSegue(withIdentifier: "showRegDetail", sender: self)
                } else {
                    self.performSegue(withIdentifier: "showMain", sender: self)
                    self.setNewRootController(nameController: "MainVC")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRegDetail" {
            let vc = segue.destination as? RegistrationDetailVC
            vc?.byPhone = true
        }
    }
}
