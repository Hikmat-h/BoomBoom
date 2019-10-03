//
//  MainEditVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/21/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SearchTextField

class MainEditVC: UIViewController, UITextFieldDelegate {

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
    
    var userInfo: EditUserInfo?
    var genderList:[GenderModel] = []
    var genderID:Int = -1
    
    //country and city objects
    var countryListModel = CountryListAnswerModel()
    var cityListModel = CityListAnswerModel()
    var countryID: Int = -1
    var cityID:Int = -1
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
//    let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OCIsImlhdCI6MTU2OTk0MTA4OSwiZXhwIjoxNTcwODA1MDg5fQ.1Yt8sY90vdyJOhNz6BIP2vOrAEBG0HYSy4bqH9DBr0osSOKB45YwHT1drVlFu_mbTlAtQBmj2RrC_IkRkkfdwQ"
    
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
        
        //set initial values
        nameLbl.text = userInfo?.name
        birthDatetextField.text = userInfo?.dateBirth
        setGenderOnBtn()
        countryField.text = userInfo?.countries.title
        cityField.text = userInfo?.cities.title
        
        // call api methods
        getGender(token: token, lang: language )
        
        //datePicker
        configureDatePicker()
        
        //country and city search field configurations
        countryField.delegate = self
        cityField.delegate = self
        cityField.isEnabled = false
        countryField.theme.font = UIFont.systemFont(ofSize: 15)
        cityField.theme.font = UIFont.systemFont(ofSize: 15)
        countryField.theme.bgColor = .lightGray
        cityField.theme.bgColor = .lightGray
        countryField.theme.cellHeight = 40
        cityField.theme.cellHeight = 40
        countryField.maxNumberOfResults = 5
        cityField.maxNumberOfResults = 5
        
        //set selected country and city IDs
        countryField.itemSelectionHandler = { filteredResults, itemIndex in
            self.countryField.text = filteredResults[itemIndex].title
            if let i = self.countryListModel.firstIndex(where: {$0.title == filteredResults[itemIndex].title}) {
                self.countryID = self.countryListModel[i].countryID
            }
            self.cityField.isEnabled = true
        }
        cityField.itemSelectionHandler = { filteredResults, itemIndex in
            self.cityField.text = filteredResults[itemIndex].title
            if let i = self.cityListModel.firstIndex(where: {$0.title == filteredResults[itemIndex].title}) {
                self.cityID = self.cityListModel[i].cityID
            }
        }
    }
    
    //MARK: - textfield delegates
       func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == countryField {
            cityField.text = ""
            cityField.isEnabled = false
           }
       }
       //method to prevent user from entering wrong country names
       func textFieldDidEndEditing(_ textField: UITextField) {
           if textField == countryField {
               if !countryListModel.contains(where: {$0.title == textField.text}) {
                   textField.text = ""
               } else {
                   self.cityField.isEnabled = true
               }
           } else if textField == cityField {
               if !cityListModel.contains(where: {$0.title == textField.text}) {
                   textField.text = ""
               }
           }
       }
       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == countryField && self.countryField.text != nil {
               let textToSearch = (textField.text ?? "") + string
            searchCounty(language: language , searchString: textToSearch, page: 0, token: token)
           } else if textField == cityField && self.cityField.text != nil{
               let textToSearch = (textField.text ?? "") + string
            searchCity(language: language , searchString: textToSearch, countryId: countryID, page: 0, token: token)
           }
           return true
       }
    
    @objc func onSave() {
        
        saveChanges(token: token, lang: language, info: userInfo!)
    }
    
    //MARK: - date picker
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
    
    //MARK: - actions
    @objc func onName() {
        let alert = UIAlertController(title: "", message: "Имя", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
//            textField.keyboardType = UIKeyboardType.alphabet
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

        genderID = genderList[gestureRecognizer.view?.tag ?? 0].id
        let selected = gestureRecognizer.view?.viewWithTag(11) as? UIImageView
        
        selected?.image = UIImage(named: "selected")
    }
    
    func setGenderOnBtn() {
        if userInfo?.sex.id == 1 {
            maleRadioV.image = UIImage(named: "selected")
        } else if userInfo?.sex.id == 2 {
            femaleRadioV.image = UIImage(named: "selected")
        } else {
            noneRadioV.image = UIImage(named: "selected")
        }
    }
    
    //MARK: - API call methods
    //might be redundant
    func getGender(token:String, lang:String) {
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        UserDetailsSerice.current.getGender(token: token, lang: lang) { (model, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if(error == nil) {
                    self.genderList = model ?? []
                } else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }
    
    func searchCity (language:String, searchString:String, countryId:Int, page:Int, token:String) {
        self.countryField.showLoadingIndicator()
        UserDetailsSerice.current.searchCity(token: token, lang: language, countryId: countryId, title: title ?? "", page: page) { (arrayModel, error) in
            DispatchQueue.main.async {
                self.cityField.stopLoadingIndicator()
                if (error != nil) {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                    
                } else {
                    self.cityListModel = arrayModel ?? []
                    self.cityField.filterStrings(self.cityListModel.map{$0.title})
                }
            }
        }
    }
    
    func searchCounty (language:String, searchString:String, page:Int, token:String) {
        self.countryField.showLoadingIndicator()
        UserDetailsSerice.current.searchCountry(token: token, lang: language, title: searchString, page: page) { (arrayModel, error) in
            DispatchQueue.main.async {
                self.countryField.stopLoadingIndicator()
                if (error != nil) {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                    
                } else {
                    self.countryListModel = arrayModel ?? []
                    self.countryField.filterStrings(self.countryListModel.map{$0.title})
                }
            }
        }
    }
    
    func saveChanges (token:String, lang:String, info:EditUserInfo) {
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        UserDetailsSerice.current.editProfileData(token: token, lang: lang, bodyTypeId: info.bodyType.id, sexId: genderID, sexualOrientation: info.sexualOrientation.id, countryId: countryID, cityId: cityID, name: nameLbl.text ?? "", dateBirth: birthDatetextField.text ?? "", information: info.information, weight: info.weight, height: info.height, breastSize: info.breastSize, pdSponsorship: info.pdSponsorship, pdSpendEvening: info.pdSpendEvening, pdPeriodicMeetings: info.pdPeriodicMeetings, pdTravels: info.pdTravels, pdFriendshipCommunication: info.pdFriendshipCommunication, hobby: info.hobby, favoritePlacesCity: info.favoritePlacesCity, visitedCountries: info.visitedCountries, countriesWantVisit: info.countriesWantVisit, hairColorId: info.hairColor.id) { (model, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if error != nil {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
