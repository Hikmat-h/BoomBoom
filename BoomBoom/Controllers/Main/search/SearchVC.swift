//
//  SearchVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import RangeSeekSlider
import SearchTextField

class SearchVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var friendshipSw: UISwitch!
    @IBOutlet weak var travelSw: UISwitch!
    @IBOutlet weak var datingSw: UISwitch!
    @IBOutlet weak var EveningSw: UISwitch!
    @IBOutlet weak var sponsorSw: UISwitch!
    @IBOutlet weak var weightCheckBox: UIButton!
    @IBOutlet weak var heightCheckBox: UIButton!
    @IBOutlet weak var ageCheckBox: UIButton!
    @IBOutlet var radioButtons: [UIButton]!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var fView: UIView!
    @IBOutlet weak var coupleView: UIView!
    @IBOutlet weak var allView: UIView!
    
    @IBOutlet weak var weightRange: RangeSeekSlider!
    @IBOutlet weak var heightRange: RangeSeekSlider!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var ageRange: RangeSeekSlider!
    @IBOutlet weak var ageLbl: UILabel!
    
    @IBOutlet weak var countryField: SearchTextField!
    @IBOutlet weak var cityField: SearchTextField!
    
    var token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    //data models
    var accounts:[SearchResult] = []
    
    //vars to send to server
    var sex:String = "all"
    var minAge:Int = 0
    var maxAge:Int = 1000
    var minHeight: Int = 0
    var maxHeight: Int = 1000
    var minWeight: Int = 0
    var maxWeight: Int = 1000
    
    //country and city objects
    var countryListModel = CountryListAnswerModel()
    var cityListModel = CityListAnswerModel()
    var countryID: Int = -1
    var cityID:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //radio button views
        let mTap = UITapGestureRecognizer(target: self, action: #selector(mTapped(_:)))
        mView.addGestureRecognizer(mTap)
        let fTap = UITapGestureRecognizer(target: self, action: #selector(fTapped(_:)))
        fView.addGestureRecognizer(fTap)
        let cTap = UITapGestureRecognizer(target: self, action: #selector(cTapped(_:)))
        coupleView.addGestureRecognizer(cTap)
        let aTap = UITapGestureRecognizer(target: self, action: #selector(aTapped(_:)))
        allView.addGestureRecognizer(aTap)
        
        ageRange.addTarget(self, action: #selector(ageValueChanged), for: .allEvents)
        heightRange.addTarget(self, action: #selector(heightValueChanged), for: .allEvents)
        weightRange.addTarget(self, action: #selector(weightValueChanged), for: .allEvents)
        
        //range slider initial states
        let gray = #colorLiteral(red: 0.4784313725, green: 0.4784313725, blue: 0.4784313725, alpha: 1)
        ageRange.handleColor = gray
        ageRange.colorBetweenHandles = gray
        ageRange.isUserInteractionEnabled = false
        
        heightRange.handleColor = gray
        heightRange.colorBetweenHandles = gray
        heightRange.isUserInteractionEnabled = false
        
        weightRange.handleColor = gray
        weightRange.colorBetweenHandles = gray
        weightRange.isUserInteractionEnabled = false
        
        //checkbox states
        let img = UIImage(named: "unchecked")?.withRenderingMode(.alwaysTemplate)
        ageCheckBox.setImage(img, for: .normal)
        ageCheckBox.tintColor = gray
        heightCheckBox.setImage(img, for: .normal)
        heightCheckBox.tintColor = gray
        weightCheckBox.setImage(img, for: .normal)
        weightCheckBox.tintColor = gray
        
        let okButton = UIBarButtonItem(image: UIImage(named: "tick"), style: .plain, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = okButton
        
        //country and city
        countryField = configureDropDownTextField(countryField, placeholder: "Все странa")
        cityField = configureDropDownTextField(cityField, placeholder: "Все городa")
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
        
        //default selected
        onRadio(radioButtons?[3] as Any)
        
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
    
    @objc func search () {
        guard let resultVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultVC else { return }
        if !(countryField.text?.isEmpty ?? true) {
            resultVC.countryID = self.countryID
        }
        if cityField.text?.isEmpty ?? true {
            resultVC.cityID = self.cityID
        }
        resultVC.sex = self.sex
        resultVC.minAge = self.minAge
        resultVC.maxAge = self.maxAge
        resultVC.minWeight = self.minWeight
        resultVC.maxWeight = self.maxWeight
        resultVC.minHeight = self.minHeight
        resultVC.maxHeight = self.maxHeight
        resultVC.travel = self.travelSw.isOn
        resultVC.friendShip = self.friendshipSw.isOn
        resultVC.dating = self.datingSw.isOn
        resultVC.evening = self.EveningSw.isOn
        resultVC.sponsor = self.EveningSw.isOn
        
        show(resultVC, sender: self)
    }
    
    @IBAction func onAgeChecked(_ sender: Any) {
        if(ageCheckBox.image(for: .normal) == UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)) {
            let gray = #colorLiteral(red: 0.4784313725, green: 0.4784313725, blue: 0.4784313725, alpha: 1)
            ageRange.handleColor = gray
            ageRange.colorBetweenHandles = gray
            ageRange.isUserInteractionEnabled = false
            let img = UIImage(named: "unchecked")?.withRenderingMode(.alwaysTemplate)
            ageCheckBox.setImage(img, for: .normal)
            ageCheckBox.tintColor = gray
        } else {
            let red = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
            ageRange.handleColor = red
            ageRange.colorBetweenHandles = red
            ageRange.isUserInteractionEnabled = true
            let img = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
            ageCheckBox.setImage(img, for: .normal)
            ageCheckBox.tintColor = red
        }
        // trick to refresh the colors of slider
        ageRange.minValue = 18
    }
    
    @IBAction func onHeightChecked(_ sender: Any) {
        if(heightCheckBox.image(for: .normal) == UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)) {
            let gray = #colorLiteral(red: 0.4784313725, green: 0.4784313725, blue: 0.4784313725, alpha: 1)
            heightRange.handleColor = gray
            heightRange.colorBetweenHandles = gray
            heightRange.isUserInteractionEnabled = false
            let img = UIImage(named: "unchecked")?.withRenderingMode(.alwaysTemplate)
            heightCheckBox.setImage(img, for: .normal)
            heightCheckBox.tintColor = gray
        } else {
            let red = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
            heightRange.handleColor = red
            heightRange.colorBetweenHandles = red
            heightRange.isUserInteractionEnabled = true
            let img = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
            heightCheckBox.setImage(img, for: .normal)
            heightCheckBox.tintColor = red
        }
        // trick to refresh the colors of slider
        heightRange.minValue = 0
    }
    
    @IBAction func onWeightChecked(_ sender: Any) {
        if(weightCheckBox.image(for: .normal) == UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)) {
            let gray = #colorLiteral(red: 0.4784313725, green: 0.4784313725, blue: 0.4784313725, alpha: 1)
            weightRange.handleColor = gray
            weightRange.colorBetweenHandles = gray
            weightRange.isUserInteractionEnabled = false
            let img = UIImage(named: "unchecked")?.withRenderingMode(.alwaysTemplate)
            weightCheckBox.setImage(img, for: .normal)
            weightCheckBox.tintColor = gray
        } else {
            let red = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
            weightRange.handleColor = red
            weightRange.colorBetweenHandles = red
            weightRange.isUserInteractionEnabled = true
            let img = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
            weightCheckBox.setImage(img, for: .normal)
            weightCheckBox.tintColor = red
        }
        // trick to refresh the colors of slider
        weightRange.minValue = 0
    }
    
    //slider selector functions
     @objc func ageValueChanged() {
        minAge = Int(ageRange.selectedMinValue)
        maxAge = Int(ageRange.selectedMaxValue)
        ageLbl.text = "\(Int(ageRange.selectedMinValue)) -  \(Int(ageRange.selectedMaxValue))"
    }
    
    @objc func heightValueChanged() {
        minHeight = Int(heightRange.selectedMinValue)
        maxHeight = Int(heightRange.selectedMaxValue)
        heightLbl.text = "\(Int(heightRange.selectedMinValue)) -  \(Int(heightRange.selectedMaxValue)) см"
    }
    
    @objc func weightValueChanged() {
        minWeight = Int(weightRange.selectedMinValue)
        maxWeight = Int(weightRange.selectedMaxValue)
        weightLbl.text = "\(Int(weightRange.selectedMinValue)) кг -  \(Int(weightRange.selectedMaxValue)) кг"
    }
    
    //radio buttons selector functions
    @objc func mTapped (_ sender: UITapGestureRecognizer? = nil) {
        sex = "man"
        onRadio(radioButtons?[0] as Any)
    }
    
    @objc func fTapped (_ sender: UITapGestureRecognizer? = nil) {
        sex = "woman"
        onRadio(radioButtons?[1] as Any)
    }
    
    @objc func cTapped (_ sender: UITapGestureRecognizer? = nil) {
        sex = "pair"
        onRadio(radioButtons?[2] as Any)
    }
    
    @objc func aTapped (_ sender: UITapGestureRecognizer? = nil) {
        sex = "all"
        onRadio(radioButtons?[3] as Any)
    }
    
    func onRadio(_ sender: Any) {
        for button in radioButtons {
            button.setImage(UIImage(named: "unselected"), for: .normal)
        }
        let selected = sender as? UIButton
        selected?.setImage(UIImage(named: "selected"), for: .normal)
    }
    
    //MARK: - textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryField {
            cityField.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == countryField {
            if !countryListModel.contains(where: {$0.title == textField.text}) {
                textField.text = ""
                countryID = -1
            } else {
                self.cityField.isEnabled = true
            }
        } else if textField == cityField {
            if !cityListModel.contains(where: {$0.title == textField.text}) {
                textField.text = ""
                cityID = -1
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
    
    // MARK: - APi call methods
    func searchCity (language:String, searchString:String, countryId:Int, page:Int, token:String) {
        self.countryField.showLoadingIndicator()
        UserDetailsSerice.current.searchCity(token: token, lang: language, countryId: countryId, title: title ?? "", page: page) { (arrayModel, error) in
            DispatchQueue.main.async {
                self.cityField.stopLoadingIndicator()
                if (error != nil) {
                    if error?.code == 401 {
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        UserDefaults.standard.synchronize()
                        //self.performSegue(withIdentifier: "showAuth", sender: self)
                        self.setNewRootController(nameController: "AuthorizationVC")
                    } else {
                        self.showErrorWindow(errorMessage: error?.domain ?? "")
                    }
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
                    if error?.code == 401 {
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        UserDefaults.standard.synchronize()
                        //self.performSegue(withIdentifier: "showAuth", sender: self)
                        self.setNewRootController(nameController: "AuthorizationVC")
                    } else {
                        self.showErrorWindow(errorMessage: error?.domain ?? "")
                    }
                    
                } else {
                    self.countryListModel = arrayModel ?? []
                    self.countryField.filterStrings(self.countryListModel.map{$0.title})
                }
            }
        }
    }

}
