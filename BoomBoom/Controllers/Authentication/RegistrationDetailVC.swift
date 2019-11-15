//
//  RegistrationDetailVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SearchTextField

class RegistrationDetailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneOrMailfield: UITextField!
    @IBOutlet weak var genderfield: UITextField!
    @IBOutlet weak var dateOfBirthfield: UITextField!
    @IBOutlet weak var languageField: UITextField!
    
    
    @IBOutlet weak var country: SearchTextField!
    @IBOutlet weak var city: SearchTextField!
    
    
    @IBOutlet weak var regBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let scrollWidth = Int(UIScreen.main.bounds.width-32)
    
    //to display mail or phone field
    var byPhone: Bool = false
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let token = UserDefaults.standard.value(forKey: "token") as! String
    
    //birthdate picker
    let datePicker = UIDatePicker()
    
    //gender
    var genders = GenderListAnswer()
    var genderID = -1
    
    //country and city objects
    var countryListModel = CountryListAnswerModel()
    var cityListModel = CityListAnswerModel()
    var countryID: Int = -1
    var cityID:Int = -1
    var language:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        nameField = Utils.current.setTextFieldStyle(nameField, placeholder: "Имя")
        let phoneOrmailPlaceholder = byPhone ? "e-mail" : "Телефон"
        phoneOrMailfield = Utils.current.setTextFieldStyle(phoneOrMailfield, placeholder: phoneOrmailPlaceholder)
        phoneOrMailfield.keyboardType = byPhone ? UIKeyboardType.emailAddress : UIKeyboardType.phonePad
        genderfield = Utils.current.setTextFieldStyle(genderfield, placeholder: "Кто Вы?")
        dateOfBirthfield = Utils.current.setTextFieldStyle(dateOfBirthfield, placeholder: "Год рождения")
        languageField = Utils.current.setTextFieldStyle(languageField, placeholder: "Выберите язык")
        country = configureDropDownTextField(country, placeholder: "странa")
        city = configureDropDownTextField(city, placeholder: "город")
        
        regBtn = Utils.current.setButtonStyle(btn: regBtn)
        
        genderfield.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGender(_:))))
        
        //birthdate
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "ok", style: .plain, target: self, action: #selector(onDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(onCancel))
        toolbar.setItems([doneButton, space, cancelButton], animated: true)
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        dateOfBirthfield.inputView = datePicker
        dateOfBirthfield.inputAccessoryView = toolbar
        
        //gender
        UserDetailsSerice.current.getGender(token: token, lang: "en") { (answerList, error) in
            if (error == nil) {
                self.genders = answerList ?? []
            } else {
                DispatchQueue.main.async {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
        
        //language
        languageField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguage(_:))))
        
        //country and city search field configurations
        country.delegate = self
        city.delegate = self
        city.isEnabled = false
        country.theme.font = UIFont.systemFont(ofSize: 15)
        city.theme.font = UIFont.systemFont(ofSize: 15)
        country.theme.bgColor = .lightGray
        city.theme.bgColor = .lightGray
        country.theme.cellHeight = 40
        city.theme.cellHeight = 40
        country.maxNumberOfResults = 5
        city.maxNumberOfResults = 5
        
        //set selected country and city IDs
        country.itemSelectionHandler = { filteredResults, itemIndex in
            self.country.text = filteredResults[itemIndex].title
            if let i = self.countryListModel.firstIndex(where: {$0.title == filteredResults[itemIndex].title}) {
                self.countryID = self.countryListModel[i].countryID
            }
            self.city.isEnabled = true
        }
        city.itemSelectionHandler = { filteredResults, itemIndex in
            self.city.text = filteredResults[itemIndex].title
            if let i = self.cityListModel.firstIndex(where: {$0.title == filteredResults[itemIndex].title}) {
                self.cityID = self.cityListModel[i].cityID
            }
        }
//        country.userStoppedTypingHandler = {
//            if let searchString = self.country.text {
//                self.country.showLoadingIndicator()
//                self.actionSearchRequest(language: "en", searchString:searchString, page: 0, token: self.token)
//            }
//        }
        
    }

    //MARK: - textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == country {
            city.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == country {
            if !countryListModel.contains(where: {$0.title == textField.text}) {
                textField.text = ""
            } else {
                self.city.isEnabled = true
            }
        } else if textField == city {
            if !cityListModel.contains(where: {$0.title == textField.text}) {
                textField.text = ""
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == country && self.country.text != nil {
            let textToSearch = (textField.text ?? "") + string
            searchCounty(language: language ?? "en", searchString: textToSearch, page: 0, token: token)
        } else if textField == city && self.city.text != nil{
            let textToSearch = (textField.text ?? "") + string
            searchCity(language: language ?? "en", searchString: textToSearch, countryId: countryID, page: 0, token: token)
        }
        return true
    }
    
    func configureDropDownTextField(_ textField: SearchTextField, placeholder: String) -> SearchTextField{
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.clipsToBounds = true
        textField.leftViewMode = UITextField.ViewMode.always
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1).cgColor
        let lightGray = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                              attributes: [NSAttributedString.Key.foregroundColor: lightGray])
        return textField
    }
    
    @objc func onCancel () {
        self.view.endEditing(true)
    }
    
    @objc func onDone () {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateOfBirthfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func onGender(_ : UITapGestureRecognizer) {
        let alert = UIAlertController(title: "", message: "Gender", preferredStyle: .actionSheet)
        for gender in genders {
            alert.addAction(UIAlertAction(title: gender.title, style: .default, handler: { (action) in
                self.genderfield.text = gender.title
                self.genderID = gender.id
                   }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onLanguage(_ : UITapGestureRecognizer) {
        let alert = UIAlertController(title: "", message: "Language", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "english", style: .default, handler: { (actioin) in
            self.languageField.text = "english"
            self.language = "en"
        }))
        alert.addAction(UIAlertAction(title: "russian", style: .default, handler: { (action) in
            self.languageField.text = "russian"
            self.language = "ru"
        }))
        //setLanguage
        UserDefaults.standard.setValue(language, forKey: "language")
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onContinue(_ sender: Any) {
        if !(nameField.text?.isEmpty ?? true) &&
            !(genderfield.text?.isEmpty ?? true) &&
            !(dateOfBirthfield.text?.isEmpty ?? true) &&
            !(languageField.text?.isEmpty ?? true) &&
            !(country.text?.isEmpty ?? true) &&
            !(city.text?.isEmpty ?? true) {
            if byPhone && isValidEmail(emailStr: phoneOrMailfield.text ?? "") {
                createUserData(token: token, lang: language ?? "", sexID: genderID, email: phoneOrMailfield.text ?? "", phone: nil, countryID: countryID, cityID: cityID, name: nameField.text ?? "", dateBirth: dateOfBirthfield.text ?? "")
            } else if !byPhone {
                createUserData(token: token, lang: language ?? "", sexID: genderID, email: nil, phone: phoneOrMailfield.text ?? "", countryID: countryID, cityID: cityID, name: nameField.text ?? "", dateBirth: dateOfBirthfield.text ?? "")
            } else {
                showErrorWindow(errorMessage: "please enter valid email address")
            }
        } else {
            showErrorWindow(errorMessage: "all fields except phone number or email is mandatory")
        }
    }
    
    //проверка почты на корректность
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    // MARK: - APi call methods
    func searchCity (language:String, searchString:String, countryId:Int, page:Int, token:String) {
        self.country.showLoadingIndicator()
        UserDetailsSerice.current.searchCity(token: token, lang: language, countryId: countryId, title: searchString, page: page) { (arrayModel, error) in
            DispatchQueue.main.async {
                self.city.stopLoadingIndicator()
                if (error != nil) {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                    
                } else {
                    self.cityListModel = arrayModel ?? []
                    self.city.filterStrings(self.cityListModel.map{$0.title})
                }
            }
        }
    }
    
    func searchCounty (language:String, searchString:String, page:Int, token:String) {
        self.country.showLoadingIndicator()
        UserDetailsSerice.current.searchCountry(token: token, lang: language, title: searchString, page: page) { (arrayModel, error) in
            DispatchQueue.main.async {
                self.country.stopLoadingIndicator()
                if (error != nil) {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                    
                } else {
                    self.countryListModel = arrayModel ?? []
                    self.country.filterStrings(self.countryListModel.map{$0.title})
                }
            }
        }
    }
    
    func createUserData(token:String, lang:String, sexID:Int, email:String?, phone:String?, countryID:Int, cityID:Int, name:String, dateBirth:String) {
        self.showActivityIndicator(loadingView: loadingView, spinner: spinner)
        UserDetailsSerice.current.createBasicProfileData(token: token, lang: lang, sexId: sexID, email: email, phone: phone, countryId: countryID, cityId: cityID, name: name, dateBirth: dateBirth) { (userInfo, error) in
            self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
            if error == nil {
                UserDefaults.standard.set(true, forKey: "auth")
                self.performSegue(withIdentifier: "showMain", sender: self)
                self.setNewRootController(nameController: "MainVC")
            } else {
                self.showErrorWindow(errorMessage: error?.domain ?? "")
            }
        }
    }
}
