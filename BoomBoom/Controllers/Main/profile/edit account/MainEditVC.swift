//
//  MainEditVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SearchTextField

enum Gender {
    case male
    case female
    case none
}

class MainEditVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var birthDatetextField: UITextField!
    
    @IBOutlet weak var countryField: SearchTextField!
    @IBOutlet weak var cityField: SearchTextField!
    
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var countryView: UIView!
    
    @IBOutlet weak var maleVIew: UIView!
    @IBOutlet weak var maleRadioV: UIImageView!
    @IBOutlet weak var noneRadioV: UIImageView!
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var femaleRadioV: UIImageView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var birthDateVIew: UIView!
    @IBOutlet weak var nameView: UIView!
    
    let birthDatePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        let button = UIBarButtonItem(image: UIImage(named: "tick"), style: .plain, target: self, action: #selector(onSave))
        self.navigationItem.rightBarButtonItem = button
        
        //gesture recognizers
        let nameGesRec = UITapGestureRecognizer(target: self, action: #selector(onName))
        nameView.addGestureRecognizer(nameGesRec)
        let birthGesRec = UITapGestureRecognizer(target: self, action: #selector(onBirthDate))
        birthDateVIew.addGestureRecognizer(birthGesRec)
        let countryGesRec = UITapGestureRecognizer(target: self, action: #selector(onCountry))
        countryView.addGestureRecognizer(countryGesRec)
        let cityGesRec = UITapGestureRecognizer(target: self, action: #selector(onCity))
        cityView.addGestureRecognizer(cityGesRec)
        
        //gender
        let tapM = UITapGestureRecognizer(target: self, action: #selector(onGender(_:)))
        maleVIew.addGestureRecognizer(tapM)
        let tapF = UITapGestureRecognizer(target: self, action: #selector(onGender(_:)))
        femaleView.addGestureRecognizer(tapF)
        let tapN = UITapGestureRecognizer(target: self, action: #selector(onGender(_:)))
        noneView.addGestureRecognizer(tapN)
        //-----
        
        //datePicker
        configureDatePicker()
        
        //country and city
        countryField.filterStrings(["Uzbekistan", "Russia", "USA", "Germany"])
        cityField.filterStrings(["Tashkent", "Moscow", "New York"])

        self.countryField.inputView = UIView()
        self.countryField.inputAccessoryView = UIView()
        self.cityField.inputView = UIView()
        self.cityField.inputAccessoryView = UIView()
        
    }
    
    @objc func onSave() {
        self.navigationController?.popViewController(animated: true)
    }
    //datePicker
    func configureDatePicker() {
        birthDatePicker.date = Date()
        birthDatePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "ОК", style: .plain, target: self, action: #selector(onDoneDatePicking))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelDatePicking));
        toolbar.setItems([doneButton, spaceButton,cancelButton], animated: true)
        birthDatetextField.inputView = birthDatePicker
        birthDatetextField.inputAccessoryView = toolbar
    }
    
    @objc func cancelDatePicking() {
        self.view.endEditing(true)
    }
    
    @objc func onDoneDatePicking() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        self.birthDatetextField.text = formatter.string(from: birthDatePicker.date)
        birthDatetextField.resignFirstResponder()
    }
    //------
    
    @objc func onName() {
        let alert = UIAlertController(title: "", message: "Имя", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.keyboardType = UIKeyboardType.alphabet
        })
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {
            (action) in
            self.nameLbl.text = "\(alert.textFields?[0].text ?? "")"
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onBirthDate() {
        birthDatetextField.becomeFirstResponder()
    }
    
    @objc func onCountry() {
        self.countryField.becomeFirstResponder()
    }
    
    @objc func onCity() {
        self.cityField.becomeFirstResponder()
    }
    
    @objc func onGender(_ gestureRecognizer: UITapGestureRecognizer) {
        let unselected = UIImage(named: "unselected")
        maleRadioV.image = unselected
        femaleRadioV.image = unselected
        noneRadioV.image = unselected

        let selected = gestureRecognizer.view?.viewWithTag(11) as? UIImageView
        selected?.image = UIImage(named: "selected")
    }
}
