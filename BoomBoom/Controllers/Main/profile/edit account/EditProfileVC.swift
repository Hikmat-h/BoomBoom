//
//  EditProfileVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/19/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import IGRPhotoTweaks

class EditProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var friendshipS: UISwitch!
    @IBOutlet weak var travelS: UISwitch!
    @IBOutlet weak var datingS: UISwitch!
    @IBOutlet weak var sponsorS: UISwitch!
    @IBOutlet weak var nightS: UISwitch!
    @IBOutlet weak var presentedView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var aimView: UIView!
    @IBOutlet weak var hairColorView: UIView!
    @IBOutlet weak var boobSizeView: UIView!
    @IBOutlet weak var bodyTypeView: UIView!
    @IBOutlet weak var orientationView: UIView!
    @IBOutlet weak var interestedCountriesTextView: UITextView!
    @IBOutlet weak var visitedCountriesTextView: UITextView!
    @IBOutlet weak var favPlacesTextView: UITextView!
    @IBOutlet weak var interestsTextView: UITextView!
    
    @IBOutlet weak var aimTextView: UITextView!
    @IBOutlet weak var hairColorlbl: UILabel!
    @IBOutlet weak var boobSize: UILabel!
    @IBOutlet weak var bodyTypelbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var orientationLbl: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var boobSizeViewHeight: NSLayoutConstraint!
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
//    let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OCIsImlhdCI6MTU2OTk0MTA4OSwiZXhwIjoxNTcwODA1MDg5fQ.1Yt8sY90vdyJOhNz6BIP2vOrAEBG0HYSy4bqH9DBr0osSOKB45YwHT1drVlFu_mbTlAtQBmj2RrC_IkRkkfdwQ"
    
    var userInformation: EditUserInfo?
    var photos:[Photo] = []
    let baseUrl = Constants.HTTP.PATH_URL
    
    var bodyTypeList:[BodyType] = []
    var genderList:[GenderModel] = []
    var orientationList:[SexualOrientationModel] = []
    var hairColorList:[HairModel] = []
    
    //chosen IDs
    var bodyTypeID:Int = -1
    var orientationID:Int = -1
    var hairID:Int = -1
    
    var cellWidth: CGFloat?
    let placeHolderColor = #colorLiteral(red: 0.5490196078, green: 0.5254901961, blue: 0.5254901961, alpha: 1)
    var aim:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        let button = UIBarButtonItem(image: UIImage(named: "tick"), style: .plain, target: self, action: #selector(onSave))
        self.navigationItem.rightBarButtonItem = button
        
        //collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        cellWidth = (UIScreen.main.bounds.width - 60)/3
        
        //textViews
        aboutTextView.text = "Расскажите что - нибудь о себе..."
        aboutTextView.textColor = .darkGray
        aboutTextView.delegate = self
        
        interestsTextView.text = "Ваши увлечения"
        interestsTextView.textColor = .darkGray
        interestsTextView.delegate = self
        
        favPlacesTextView.text = "Ваши любимые места в городе"
        favPlacesTextView.textColor = .darkGray
        favPlacesTextView.delegate = self
        
        visitedCountriesTextView.text = "В каких странах вы бывали"
        visitedCountriesTextView.textColor = .darkGray
        visitedCountriesTextView.delegate = self
        
        interestedCountriesTextView.text = "В каких странах хотели бы побывать"
        interestedCountriesTextView.textColor = .darkGray
        interestedCountriesTextView.delegate = self
        
        //--- call api methods to get lists. 1 time is enough
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        getBodyType(token: token, lang: language)
        getHairColor(token: token, lang: language)
        getOrientation(token: token, lang: language)
        
        //aim
        sponsorS.isOn = userInformation?.pdSponsorship ?? false
        nightS.isOn = userInformation?.pdSpendEvening ?? false
        travelS.isOn = userInformation?.pdTravels ?? false
        datingS.isOn = userInformation?.pdPeriodicMeetings ?? false
        friendshipS.isOn = userInformation?.pdFriendshipCommunication ?? false
        
        //tap gestures
        let orGesRec = UITapGestureRecognizer(target: self, action: #selector(onOrientation))
        orientationView.addGestureRecognizer(orGesRec)
        let weightGesRec = UITapGestureRecognizer(target: self, action: #selector(onWeight))
        weightView.addGestureRecognizer(weightGesRec)
        let heightGesRec = UITapGestureRecognizer(target: self, action: #selector(onHeight))
        heightView.addGestureRecognizer(heightGesRec)
        let bodyTypeGesRec = UITapGestureRecognizer(target: self, action: #selector(onBodyType))
        bodyTypeView.addGestureRecognizer(bodyTypeGesRec)
        let boobSizeGesRec = UITapGestureRecognizer(target: self, action: #selector(onBoobSize))
        boobSizeView.addGestureRecognizer(boobSizeGesRec)
        let hairColorGesRec = UITapGestureRecognizer(target: self, action: #selector(onHairColor))
        hairColorView.addGestureRecognizer(hairColorGesRec)
        let aimGesRec = UITapGestureRecognizer(target: self, action: #selector(onAim))
        aimView.addGestureRecognizer(aimGesRec)
        aim.append("Cпонсорство")
        aim.append("Провести вечер")
        aim.append("Периодические встречи")
        aim.append("Совместные путешествия")
        aim.append("Дружба и общение")
        
        presentedView.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //nav bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        boobSizeView.isHidden = true
        getUserInfo(token: token, lang: language)
        //set aim textView texts
        onOk(self)
    }
    
    func updateInfoData () {
        //put fresh data
        self.photos = userInformation?.photos ?? []
        self.collectionView.reloadData()
        if !userInformation!.information.isEmpty {
            aboutTextView.textColor = .white
            aboutTextView.text = "\(userInformation?.information ?? "")"
        }
        self.orientationLbl.text = "\(userInformation?.sexualOrientation.title ?? "")"
        if ((userInformation?.weight) != nil) {
            weightLbl.text = "\(userInformation?.weight ?? 0)"
        }
        if ((userInformation?.height) != nil) {
            heightLbl.text = "\(userInformation?.height ?? 0)"
        }
        self.bodyTypelbl.text = "\(userInformation?.bodyType.title ?? "")"
        if userInformation?.sex.id == 2 {
            boobSizeViewHeight.constant = 44
            boobSizeView.isHidden = false
            boobSizeView.layoutIfNeeded()
            boobSize.text = "\(userInformation?.breastSize ?? 0)"
        } else {
            boobSizeView.isHidden = true
            boobSizeViewHeight.constant = 0
            boobSizeView.layoutIfNeeded()
        }
        self.hairColorlbl.text = userInformation?.hairColor.title
        if !userInformation!.hobby.isEmpty {
            interestsTextView.textColor = .white
            interestsTextView.text = userInformation?.hobby
        }
        if !userInformation!.favoritePlacesCity.isEmpty {
            favPlacesTextView.textColor = .white
            favPlacesTextView.text = userInformation?.favoritePlacesCity
        }
        if !userInformation!.visitedCountries.isEmpty {
            visitedCountriesTextView.textColor = .white
            visitedCountriesTextView.text = userInformation?.visitedCountries
        }
        if !userInformation!.countriesWantVisit.isEmpty {
            interestedCountriesTextView.textColor = .white
            interestedCountriesTextView.text = userInformation?.countriesWantVisit
        }
    }
    @objc func onSave() {
        saveChanges(token: token, lang: language)
    }
    
    //MARK: - API calls
    func getBodyType(token:String, lang:String) {
        UserDetailsSerice.current.getBodyType(token: token, lang: lang) { (model, error) in
            if(error == nil) {
                self.bodyTypeList = model ?? []
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }
    
    func getHairColor(token:String, lang:String) {
        UserDetailsSerice.current.getHairColor(token: token, lang: lang) { (model, error) in
            if(error == nil) {
                self.hairColorList = model ?? []
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }
    
    func getOrientation(token:String, lang:String) {
        UserDetailsSerice.current.getOrientation(token: token, lang: lang) { (model, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if(error == nil) {
                    self.orientationList = model ?? []
                } else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }
    
    func saveChanges(token:String, lang:String) {
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        UserDetailsSerice.current.editProfileData(token: token, lang: lang, bodyTypeId: bodyTypeID, sexId: userInformation?.sex.id ?? 0, sexualOrientation: orientationID, countryId: userInformation?.countries.countryID ?? 0, cityId: userInformation?.cities.cityID ?? 0, name: userInformation?.name ?? "", dateBirth: userInformation?.dateBirth ?? "", information: aboutTextView.text, weight: Int(weightLbl.text ?? "") ?? 0, height: Int(heightLbl.text ?? "") ?? 0, breastSize: Int(boobSize.text ?? ""), pdSponsorship: sponsorS.isOn, pdSpendEvening: nightS.isOn, pdPeriodicMeetings: datingS.isOn, pdTravels: travelS.isOn, pdFriendshipCommunication: friendshipS.isOn, hobby: interestsTextView.text, favoritePlacesCity: favPlacesTextView.text, visitedCountries: interestedCountriesTextView.text, countriesWantVisit: interestedCountriesTextView.text, hairColorId: hairID) { (model, error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // to get updated  info
    func getUserInfo(token:String, lang:String) {
        self.showActivityIndicator(loadingView: loadingView, spinner: spinner)
        UserDetailsSerice.current.getProfileDetails(token: token, lang: "en") { (userInfoModel, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if (error == nil) {
                    self.userInformation = userInfoModel
                    self.updateInfoData()
                } else {
                    self.showErrorWindow(errorMessage: error!.domain)
                }
            }
        }
    }
    
    //MARK: - presented alerts when fields are selected
    @objc func onOrientation() {
        let alert = UIAlertController(title: "", message: "Ориентация", preferredStyle: .actionSheet)
        for orient in orientationList {
            alert.addAction(UIAlertAction(title: orient.title, style: .default, handler: {
                (action) -> Void in
                self.orientationID = orient.id
                self.orientationLbl.text = orient.title
            }))
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onWeight() {
        let alert = UIAlertController(title: "", message: "Вес", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "0 - 230 кг."
            textField.keyboardType = UIKeyboardType.numberPad
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            let weight = Int(alert.textFields?[0].text ?? "0") ?? 0
            if weight>=0 && weight<=230 {
             self.weightLbl.text = "\(alert.textFields?[0].text ?? "") кг"
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onHeight() {
        let alert = UIAlertController(title: "", message: "Рост", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "0 - 250 см."
            textField.keyboardType = UIKeyboardType.numberPad
        })
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {
            (action) in
            let height = Int(alert.textFields?[0].text ?? "0") ?? 0
            if height>=0 && height<=250 {
                self.heightLbl.text = "\(alert.textFields?[0].text ?? "") см."
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onBodyType() {
        let alert = UIAlertController(title: "", message: "Телосложение", preferredStyle: .actionSheet)
        for body in bodyTypeList {
            alert.addAction(UIAlertAction(title: body.title, style: .default, handler: {
                (action) -> Void in
                self.bodyTypeID = body.id
                self.bodyTypelbl.text = body.title
            }))
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onBoobSize() {
        let alert = UIAlertController(title: "", message: "Размер груди", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "1 - 6"
            textField.keyboardType = UIKeyboardType.numberPad
        })
        alert.addAction(UIAlertAction(title: "Oк", style: .default, handler: {
            (action) in
            let size = Int(alert.textFields?[0].text ?? "0") ?? 0
            if size>=1 && size<=6 {
                self.boobSize.text = "\(size)"
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onHairColor() {
        let alert = UIAlertController(title: "", message: "Цвет волос", preferredStyle: .actionSheet)
        for hair in hairColorList {
            alert.addAction(UIAlertAction(title: hair.title, style: .default, handler: {
                (action) -> Void in
                self.hairID = hair.id
                self.hairColorlbl.text = hair.title
            }))
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //presented view button actions
    @IBAction func onCancel(_ sender: Any) {
        UIView.transition(with: backgroundView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView.alpha = 0
        }, completion: nil)
    }
    
    //aim ok button pressed
    @IBAction func onOk(_ sender: Any) {
        aimTextView.text = "Цель знакомства: "
        aimTextView.text = aimTextView.text! + (sponsorS.isOn ? aim[0] : "") + " \u{2022} "
        aimTextView.text = aimTextView.text! + (nightS.isOn ? (aim[1]) : "") + " \u{2022} "
        aimTextView.text = aimTextView.text! + (datingS.isOn ? (aim[2]) : "") + " \u{2022} "
        aimTextView.text = aimTextView.text! + (travelS.isOn ? (aim[3]) : "") + " \u{2022} "
        aimTextView.text = aimTextView.text! + (friendshipS.isOn ? (aim[4]) : "") + " \u{2022} "
        
        UIView.transition(with: backgroundView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView.alpha = 0
        }, completion: nil)
    }
    
    //aim Button Actions. Presents view with animation
    @objc func onAim() {
        UIView.transition(with: backgroundView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView.alpha = 1
        }, completion: nil)
    }
    
    //MARK: - photo collection view data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editPhotoCell", for: indexPath) as! PhotoCollectionCell
        if(indexPath.row < photos.count) {
            let url = baseUrl + "/" + photos[indexPath.row].pathURLPreview
            cell.photoView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "plusImg"))
        } else {
            cell.photoView.image = UIImage(named: "plusImg")
        }
        return cell
    }
    
    //size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth ?? 105, height:cellWidth ?? 105)
    }
    
    //space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14.0
    }
    //----
    
    //MARK: - textField delegates for imitating placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView==aboutTextView{
            textView.text = "Расскажите что - нибудь о себе..."
            textView.textColor = UIColor.darkGray
        } else if textView.text.isEmpty && textView==interestsTextView{
            textView.text = "Ваши увлечения"
            textView.textColor = UIColor.darkGray
        } else if textView.text.isEmpty && textView==favPlacesTextView{
            textView.text = "Ваши любимые места в городе"
            textView.textColor = UIColor.darkGray
        } else if textView.text.isEmpty && textView==visitedCountriesTextView{
            textView.text = "В каких странах вы бывали"
            textView.textColor = UIColor.darkGray
        } else if textView.text.isEmpty && textView==interestedCountriesTextView{
            textView.text = "В каких странах хотели бы побывать"
            textView.textColor = UIColor.darkGray
        }
    }
    
    //when going to main edit view controller
    @IBAction func onMain(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMainEditVC" {
            let vc = segue.destination as? MainEditVC
            vc?.userInfo = userInformation!
        } else if segue.identifier == "showEdit" {

            let vc = segue.destination as! PhotoEditVC
            let cell = sender as? PhotoCollectionCell
            vc.image = cell?.photoView.image
            vc.delegate = self as? IGRPhotoTweakViewControllerDelegate
        }
    }
    
}
