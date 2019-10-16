//
//  TestVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/16/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class LikePhotoVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    let screenSize = UIScreen.main.bounds.size
    var userID:Int?
    var loadingView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    var token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"

    let baseURL = Constants.HTTP.PATH_URL
    
    var userInformation: OtherProfile?
    var infoArray:[String] = []
    var infoTitleArray:[String] = []
    var avatar:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        let phone = UIBarButtonItem(image: UIImage(named: "phone")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onPhone))
        self.navigationItem.rightBarButtonItem = phone
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        getAccount(token: token, lang: language, id: userID ?? -1)
    }
    
    @objc func onPhone() {
        print("wanna get phone number?")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell") as! PhotosCell
            cell.photos = userInformation?.photos ?? []
            cell.cityLbl.text = userInformation?.cities.title
            cell.nameAndAgelbl.text = "\(userInformation?.name ?? ""), \(self.comuteAge(userInformation?.dateBirth ?? ""))"
            cell.updatePageScroller()
            if ((userInformation?.photos.count ?? 0) > 0){
                avatar = userInformation?.photos.first(where: {$0.main == true})
            }
            return cell
        } else if indexPath.row>0 && indexPath.row<5 && indexPath.row<infoArray.count+1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoCell
            cell.titleLbl.text = infoTitleArray[indexPath.row - 1]
            cell.textVIew.text = infoArray[indexPath.row - 1]
            return cell
        } else if indexPath.row == infoArray.count+1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "verificationCell") as! VerificationCell
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionsCell") as! ActionsCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.height
        } else if indexPath.row > 0 && indexPath.row < 5 {
            return 180
        } else {
            return 135
        }
    }
    
    func setUserInfo(infoModel:OtherProfile) {
        
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
        self.tableView.reloadData()
    }
    
    //converts userInfo object into array and sets lable values
    func comuteAge(_ dateBirth:String)->Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let timeSince = Date().timeIntervalSince(formatter.date(from: dateBirth) ?? Date())
        let age = Int(timeSince/31536000)
        return age
    }
    
    //MARK: - APi call
    func getAccount(token:String, lang:String, id:Int){
        self.showActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
           NewsService.current.getAccount(token: token, lang: lang, id: id) { (info, error) in
               DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if error == nil {
                    self.setUserInfo(infoModel: info!)
                } else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
               }
           }
       }

}
