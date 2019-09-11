//
//  RegistrationVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/9/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    //phone
    @IBOutlet var phoneView: UIView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var regBtn2: UIButton!
    @IBOutlet weak var switch2: UISwitch!
    
    //email
    @IBOutlet var emailView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var regBtn: UIButton!
    
    //scrollViews
    @IBOutlet weak var stickScrollView: UIScrollView!
    @IBOutlet weak var stickView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var authSegmentedControl: UISegmentedControl!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    
    var lastContentOffset: CGFloat = 0
    let regular: CGPoint = CGPoint(x: 0, y: 0)
    let scrollWidth = Int(UIScreen.main.bounds.width-32)
    var segmentWidth: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneField = Utils.current.setTextFieldStyle(phoneField, placeholder: "Телефон")
        emailField = Utils.current.setTextFieldStyle(emailField, placeholder: "E-mail")
        passwordField = Utils.current.setTextFieldStyle(passwordField, placeholder: "Пароль")
        password2Field = Utils.current.setTextFieldStyle(password2Field, placeholder: "Повторите пароль")
        regBtn = Utils.current.setButtonStyle(btn: regBtn)
        regBtn2 = Utils.current.setButtonStyle(btn: regBtn2)
        
        stickView.layer.cornerRadius = 2
        
        //segmentedControl
        segmentWidth = Double(stickScrollView.frame.size.width)
        stickScrollView.contentSize = CGSize(width: segmentWidth, height: 4)
        stickView.frame = CGRect(x: 0, y: 0, width: segmentWidth/2, height: 4)
        
        authSegmentedControl.layer.cornerRadius = 0
        authSegmentedControl.layer.borderWidth = 0.0
        UISegmentedControl.appearance().tintColor = .clear
        authSegmentedControl.addTarget(self, action: #selector(onSegmentChange), for: .valueChanged)
        
        //scrollViews
        mainScrollView.delegate = self
        
        verticalScrollView.contentSize = CGSize(width: scrollWidth, height: 400)
        mainScrollView.contentSize = CGSize(width: scrollWidth*2, height: 400)
        emailView.frame = CGRect(x: 0, y: 0, width: scrollWidth, height: 400)
        phoneView.frame = CGRect(x: scrollWidth, y: 0, width: scrollWidth, height: 400)
        mainScrollView.addSubview(emailView)
        mainScrollView.addSubview(phoneView)
        
        self.lastContentOffset = mainScrollView.contentOffset.x
        
        //textfields
        phoneField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        password2Field.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        onSegmentChange()
    }
    
    //segmentedControl methods
    @objc func onSegmentChange() {
        if authSegmentedControl.selectedSegmentIndex == 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            stickScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            mainScrollView.setContentOffset(CGPoint(x: scrollWidth, y: 0), animated: true)
            stickScrollView.setContentOffset(CGPoint(x: -segmentWidth/2, y: 0), animated: true)
        }
        self.view.endEditing(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView==mainScrollView)
        {
        if scrollView == mainScrollView {
            if lastContentOffset > scrollView.contentOffset.x && scrollView.contentOffset.x>0 {
                mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                stickScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                authSegmentedControl.selectedSegmentIndex = 0
            } else if lastContentOffset < scrollView.contentOffset.x && scrollView.contentOffset.x < 300 {
                mainScrollView.setContentOffset(CGPoint(x: scrollWidth, y: 0), animated: true)
                stickScrollView.setContentOffset(CGPoint(x: -segmentWidth/2, y: 0), animated: true)
                authSegmentedControl.selectedSegmentIndex = 1
                
            }
            
            }
            
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == mainScrollView {
            targetContentOffset.pointee = scrollView.contentOffset
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onRegByMail(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.NAME_SEGUE.REG_TO_REG_DETAIL, sender: self)
    }
    
    @IBAction func onRegByPhone(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.NAME_SEGUE.REG_TO_SMS, sender: self)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
