//
//  EditProfileVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/19/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

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
    
    var cellWidth: CGFloat?
    let placeHolderColor = #colorLiteral(red: 0.5490196078, green: 0.5254901961, blue: 0.5254901961, alpha: 1)
    var aim:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //---
        
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
    }
    
    //alert methods
    @objc func onOrientation() {
        let alert = UIAlertController(title: "", message: "Ориентация", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "гетеросексуализм", style: .default, handler: {
            (action) -> Void in
            self.orientationLbl.text = "гетеросексуализм"
        }))
        alert.addAction(UIAlertAction(title: "гомосексуализм", style: .default, handler: {
            (action) -> Void in
            self.orientationLbl.text = "гомосексуализм"
        }))
        alert.addAction(UIAlertAction(title: "бисексуальность", style: .default, handler: {
            (action) -> Void in
            self.orientationLbl.text = "бисексуальность"
        }))
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
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {
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
        alert.addAction(UIAlertAction(title: "худощавое", style: .default, handler: {
            (action) -> Void in
            self.bodyTypelbl.text = "худощавое"
        }))
        alert.addAction(UIAlertAction(title: "обычное", style: .default, handler: {
            (action) -> Void in
            self.bodyTypelbl.text = "обычное"
        }))
        alert.addAction(UIAlertAction(title: "спортивное", style: .default, handler: {
            (action) -> Void in
            self.bodyTypelbl.text = "спортивное"
        }))
        alert.addAction(UIAlertAction(title: "плотное", style: .default, handler: {
            (action) -> Void in
            self.bodyTypelbl.text = "плотное"
        }))
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
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {
            (action) in
            let height = Int(alert.textFields?[0].text ?? "0") ?? 0
            if height>=1 && height<=6 {
                self.boobSize.text = "\(alert.textFields?[0].text ?? "")"
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onHairColor() {
        let alert = UIAlertController(title: "", message: "Цвет волос", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "блондинка(ин)", style: .default, handler: {
            (action) -> Void in
            self.hairColorlbl.text = "блондинка(ин)"
        }))
        alert.addAction(UIAlertAction(title: "брюнетка(нет)", style: .default, handler: {
            (action) -> Void in
            self.hairColorlbl.text = "брюнетка(нет)"
        }))
        alert.addAction(UIAlertAction(title: "шатенка(ен)", style: .default, handler: {
            (action) -> Void in
            self.hairColorlbl.text = "шатенка(ен)"
        }))
        alert.addAction(UIAlertAction(title: "рыжая(ый)", style: .default, handler: {
            (action) -> Void in
            self.hairColorlbl.text = "рыжая(ый)"
        })) //русая(ый)
        alert.addAction(UIAlertAction(title: "русая(ый)", style: .default, handler: {
            (action) -> Void in
            self.hairColorlbl.text = "русая(ый)"
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //aim Button Actions
    @IBAction func onCancel(_ sender: Any) {
        UIView.transition(with: backgroundView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView.alpha = 0
        }, completion: nil)
    }
    
    @IBAction func onOk(_ sender: Any) {
        aimTextView.text = "Цель знакомства: "
        aimTextView.text = aimTextView.text! + (sponsorS.isOn ? aim[0] : "")
        aimTextView.text = aimTextView.text! + (nightS.isOn ? (", " + aim[1]) : "")
        aimTextView.text = aimTextView.text! + (datingS.isOn ? (", " + aim[2]) : "")
        aimTextView.text = aimTextView.text! + (travelS.isOn ? (", " + aim[3]) : "")
        aimTextView.text = aimTextView.text! + (friendshipS.isOn ? (", " + aim[4]) : "")
        
        UIView.transition(with: backgroundView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView.alpha = 0
        }, completion: nil)
    }
    //------
    
    @objc func onAim() {
        UIView.transition(with: backgroundView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView.alpha = 1
        }, completion: nil)
    }
    //-------
    
    //photo collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editPhotoCell", for: indexPath) as! PhotoCollectionCell
        if(indexPath.row == 0) {
            cell.photoView.image = UIImage(named: "test6")
        } else {
            cell.photoView.image = UIImage(named: "plusImg")
        }
        return cell
    }
    //------
    
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
    
    //textView placeholder imitation
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
    
    @IBAction func onMain(_ sender: Any) {
    }
    
}
