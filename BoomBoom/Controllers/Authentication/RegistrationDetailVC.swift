//
//  RegistrationDetailVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class RegistrationDetailVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneOrMailfield: UITextField!
    @IBOutlet weak var genderfield: UITextField!
    @IBOutlet weak var dateOfBirthfield: UITextField!
    @IBOutlet weak var languageField: UITextField!
    
    @IBOutlet weak var countryField: UITextField!
    
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var regBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let scrollWidth = Int(UIScreen.main.bounds.width-32)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField = Utils.current.setTextFieldStyle(nameField, placeholder: "Имя")
        phoneOrMailfield = Utils.current.setTextFieldStyle(phoneOrMailfield, placeholder: "Телефон/e-mail")
        genderfield = Utils.current.setTextFieldStyle(genderfield, placeholder: "Кто Вы?")
        dateOfBirthfield = Utils.current.setTextFieldStyle(dateOfBirthfield, placeholder: "Год рождения")
        languageField = Utils.current.setTextFieldStyle(languageField, placeholder: "Выберите язык")
        countryField = Utils.current.setTextFieldStyle(countryField, placeholder: "Страна")
        cityField = Utils.current.setTextFieldStyle(cityField, placeholder: "Город")
        regBtn = Utils.current.setButtonStyle(btn: regBtn)

        //scrollView.contentSize = CGSize(width: scrollWidth, height: 3000)
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
