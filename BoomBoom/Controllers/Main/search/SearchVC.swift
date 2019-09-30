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

class SearchVC: UIViewController {

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
    
    var minAge:Int?
    var maxAge:Int?
    var minHeight: Int?
    var maxHeight: Int?
    var minWeight: Int?
    var maxWeight: Int?
    
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
        
        //default values
        minAge = 25
        maxAge = 39
        minHeight = 150
        maxHeight = 190
        minWeight = 60
        maxWeight = 160
        
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
        countryField.layer.borderWidth = 1
        countryField.layer.borderColor = UIColor.white.cgColor
        countryField.layer.cornerRadius = 5
        cityField.layer.borderWidth = 1
        cityField.layer.cornerRadius = 5
        cityField.layer.borderColor = UIColor.white.cgColor
        countryField.filterStrings(["Uzbekistan", "Russia", "USA", "Germany"])
        cityField.filterStrings(["Tashkent", "Moscow", "New York"])
        
//        self.countryField.inputView = UIView()
//        self.countryField.inputAccessoryView = UIView()
//        self.cityField.inputView = UIView()
//        self.cityField.inputAccessoryView = UIView()
    }
    
    @objc func search () {
        print("search me")
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
        ageLbl.text = "\(Int(ageRange.selectedMinValue)) -  \(Int(ageRange.selectedMaxValue))"
    }
    
    @objc func heightValueChanged() {
        heightLbl.text = "\(Int(heightRange.selectedMinValue)) -  \(Int(heightRange.selectedMaxValue)) см"
    }
    
    @objc func weightValueChanged() {
        weightLbl.text = "\(Int(weightRange.selectedMinValue)) кг -  \(Int(weightRange.selectedMaxValue)) кг"
    }
    
    //radio buttons selector functions
    @objc func mTapped (_ sender: UITapGestureRecognizer? = nil) {
        onRadio(radioButtons?[0] as Any)
    }
    
    @objc func fTapped (_ sender: UITapGestureRecognizer? = nil) {
        onRadio(radioButtons?[1] as Any)
    }
    
    @objc func cTapped (_ sender: UITapGestureRecognizer? = nil) {
        onRadio(radioButtons?[2] as Any)
    }
    
    @objc func aTapped (_ sender: UITapGestureRecognizer? = nil) {
        onRadio(radioButtons?[3] as Any)
    }
    
    func onRadio(_ sender: Any) {
        for button in radioButtons {
            button.setImage(UIImage(named: "unselected"), for: .normal)
        }
        let selected = sender as? UIButton
        selected?.setImage(UIImage(named: "selected"), for: .normal)
    }

}
