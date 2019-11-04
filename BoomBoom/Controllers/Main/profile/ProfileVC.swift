//
//  ProfileVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    var token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"

    let baseURL = Constants.HTTP.PATH_URL
    
    var userInformation: UserInfo?
    var infoArray:[String] = []
    var infoTitleArray:[String] = []
    var avatar:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        navigationItem.hidesBackButton = true
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //clear arrays
        infoArray.removeAll()
        infoTitleArray.removeAll()
        //nav bar
        self.navigationController?.navigationBar.barTintColor = .black
        getUserInfo(token: token, lang: language)
    }
    
    // MARK: - main tableView dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if infoArray.isEmpty {
//            return 0
//        }
        return infoArray.count + 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row==0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoCell") as! ProfilePhotoCell
            if ((userInformation?.photos.count ?? 0) > 0) {
                avatar = userInformation?.photos.first(where: {$0.main == true})
                let url = baseURL + "/" + (avatar?.pathURL ?? "")
                cell.mainPhotoImgV?.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
            } else {
                cell.mainPhotoImgV.image = UIImage(named: "default_ava")
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActionCell") as! ProfileActionCell
            cell.nameAndAgeLbl.text = "\(userInformation?.name ?? ""), \(Utils.current.comuteAge(userInformation?.dateBirth ?? ""))"
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfilePhotosCell") as! UserProfilePhotosCell
            cell.numOfPhotosLbl.text = "\(userInformation?.photos.count ?? 0) фотографии"
            cell.userPhotos = userInformation?.photos ?? []
            cell.parentVC = self
            cell.photosCollectionView.reloadData()
            return cell
        } else if indexPath.row >= 3 && indexPath.row < (3+infoArray.count) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            //remove constant 3 cells to get index
            cell.infoTextView.text = infoArray[indexPath.row - 3]
            cell.infoTitleLbl.text = infoTitleArray[indexPath.row - 3]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VerificationCell") as! VerificationCell
            let url = baseURL + "/" + (avatar?.pathURLPreview ?? "")
            cell.verifPhotoView.layer.cornerRadius = 26
            if ((userInformation?.photos.count ?? 0) > 0) {
                cell.verifPhotoView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
            } else {
                cell.verifPhotoView.image = UIImage(named: "default_ava")
            }
            switch userInformation?.verification.id {
            case 2:
                cell.titleTextView.text = "Верификация пройдена"
                cell.verifStateImgView.isHidden = false
                cell.verifStateImgView.image = UIImage(named: "verifConfirmed")
            case 1, 3:
                cell.titleTextView.text = "Пройти верификацию"
                cell.verifStateImgView.isHidden = true
            case 4:
                cell.titleTextView.text = "Мы получили ваше фото и оно будет проверено в ближайшее время"
                cell.verifStateImgView.isHidden = false
                cell.verifStateImgView.image = UIImage(named: "verifTime")
            default:
                cell.titleTextView.text = "Пройти верификацию"
                cell.verifStateImgView.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            //image cell
            return 382
        } else if indexPath.row == 1 || indexPath.row == 2 {
            //action cell
            return 210
        } else {
            //other cells
            return 180
        }
    }
    
    func setUserInfo(infoModel:UserInfo) {
        
        self.userInformation = infoModel
        if (!(self.userInformation!.information?.isEmpty ?? true)) {
            self.infoTitleArray.append("Обо мне")
            self.infoArray.append(userInformation?.information ?? "")
        }
        var aim = ""
        aim += userInformation!.pdTravels ? "Совместные путешествия \u{2022} " : ""
        aim += userInformation!.pdSponsorship ? "Cпонсорство \u{2022} " : ""
        aim += userInformation!.pdSpendEvening ? "Провести вечер \u{2022} " : ""
        aim += userInformation!.pdPeriodicMeetings ? "Периодические встречи \u{2022} " : ""
        aim += userInformation!.pdFriendshipCommunication ? "Дружба и общение \u{2022} " : ""
        
        if !aim.isEmpty {
            //removes last dot
            var a = aim
            let removingIndex = a.index(a.endIndex, offsetBy: -2)
            if a[removingIndex] == "\u{2022}" {
                a.remove(at: removingIndex)
                aim = a
            }
            self.infoTitleArray.append("Цель знакомства")
            self.infoArray.append(aim)
        }
        
        if !(userInformation!.hobby?.isEmpty ?? true) {
            self.infoTitleArray.append("Увлечения")
            self.infoArray.append(userInformation!.hobby ?? "")
        }
        
        var others = ""
        if userInformation?.sex.id == 1 {
            if !(userInformation!.favoritePlacesCity?.isEmpty ?? true) {
                others += "Мои любимые места в городе \(userInformation?.favoritePlacesCity ?? ""). "
            }
            if !(userInformation!.visitedCountries?.isEmpty ?? true) {
                others += "Я был: \(userInformation?.visitedCountries ?? ""). "
            }
            if !(userInformation!.countriesWantVisit?.isEmpty ?? true) {
                others += "Я хотел бы посетить \(userInformation?.countriesWantVisit ?? ""). "
            }
        } else if userInformation!.sex.id == 2 {
            if !(userInformation!.favoritePlacesCity?.isEmpty ?? true) {
                others += "Мои любимые места в городе \(userInformation?.favoritePlacesCity ?? ""). "
            }
            if !(userInformation!.visitedCountries?.isEmpty ?? true) {
                others += "Я была: \(userInformation?.visitedCountries ?? ""). "
            }
            if !(userInformation!.countriesWantVisit?.isEmpty ?? true) {
                others += "Я хотела бы посетить \(userInformation?.countriesWantVisit ?? ""). "
            }
        } else {
            if !(userInformation!.favoritePlacesCity?.isEmpty ?? true) {
                others += "Наши любимые места в городе \(userInformation?.favoritePlacesCity ?? ""). "
            }
            if !(userInformation!.visitedCountries?.isEmpty ?? true) {
                others += "Мы были: \(userInformation?.visitedCountries ?? ""). "
            }
            if !(userInformation!.countriesWantVisit?.isEmpty ?? true) {
                
                others += "Мы хотели бы посетить \(userInformation?.countriesWantVisit ?? ""). "
            }
        }
        if !others.isEmpty {
            self.infoTitleArray.append("Отдых и досуг")
            self.infoArray.append(others)
        }
        self.mainTableView.reloadData()
    }
    
    //MARK: - API request methods
    func getUserInfo(token:String, lang:String) {
        self.showActivityIndicator(loadingView: loadingView, spinner: spinner)
        UserDetailsSerice.current.getProfileDetails(token: token, lang: lang) { (userInfoModel, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if (error == nil) {
                    self.setUserInfo(infoModel: userInfoModel!)
                } else if error?.code == 401 {
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    //self.performSegue(withIdentifier: "showAuth", sender: self)
                    self.setNewRootController(nameController: "AuthorizationVC")
                } else {
                    self.showErrorWindow(errorMessage: error!.domain)
                }
            }
        }
    }
    
    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "takeUpSegue":
            let vc = segue.destination as? ExtendSubscriptionVC
            vc?.info = "Анкета будет поднята наверх в течении 5 минут!"
            vc?.up = true
        case "subscriptionSegue":
            let vc = segue.destination as? ExtendSubscriptionVC
            vc?.info = "Оформив подписку, вы получаете возможность общения в чатах с другими пользователями."
            vc?.up = false
        case "showEditProfile":
            let vc = segue.destination as? EditProfileVC
            vc?.userInformation = self.userInformation
        default:
            return
        }
    }
}
