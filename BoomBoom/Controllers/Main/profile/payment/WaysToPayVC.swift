//
//  WaysToPayVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/23/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class WaysToPayVC: UIViewController {

    @IBOutlet weak var cardNumField: UITextField!
    @IBOutlet weak var ownerNameField: UITextField!
    @IBOutlet weak var expireDateField: UITextField!
    @IBOutlet weak var cvcField: UITextField!
    @IBOutlet weak var totalSumLbl: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalSumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Способ оплаты"
        
        totalSumView.layer.cornerRadius = 5
        
        cardNumField = Utils.current.setTextFieldStyle(cardNumField, placeholder: "Номер карты")
        ownerNameField = Utils.current.setTextFieldStyle(ownerNameField, placeholder: "Имя владельца карты")
        expireDateField = Utils.current.setTextFieldStyle(expireDateField, placeholder: "ММ/ГГ")
        cvcField = Utils.current.setTextFieldStyle(cvcField, placeholder: "CVC - код")
        
        payBtn = Utils.current.setButtonStyle(btn: payBtn)
    }

}
