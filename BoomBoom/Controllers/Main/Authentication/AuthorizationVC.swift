//
//  AuthorizationVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/9/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    //phone
    @IBOutlet var phoneView: UIView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var loginBtn2: UIButton!
    
    //email
    @IBOutlet var emailView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    //scrollViews
    @IBOutlet weak var stickScrollView: UIScrollView!
    @IBOutlet weak var stickView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var logSegmentedControl: UISegmentedControl!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    
    var lastContentOffset: CGFloat = 0
    let regular: CGPoint = CGPoint(x: 0, y: 0)
    let scrollWidth = Int(UIScreen.main.bounds.width-32)
    var segmentWidth: Double = 0.0
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneField = Utils.current.setTextFieldStyle(phoneField, placeholder: "Телефон")
        emailField = Utils.current.setTextFieldStyle(emailField, placeholder: "E-mail")
        passwordField = Utils.current.setTextFieldStyle(passwordField, placeholder: "Пароль")
        loginBtn = Utils.current.setButtonStyle(btn: loginBtn)
        loginBtn2 = Utils.current.setButtonStyle(btn: loginBtn2)
        
        stickView.layer.cornerRadius = 2
        //segmentedControl
        segmentWidth = Double(stickScrollView.frame.size.width)
        stickScrollView.contentSize = CGSize(width: segmentWidth, height: 4)
        stickView.frame = CGRect(x: 0, y: 0, width: segmentWidth/2, height: 4)
        
        logSegmentedControl.layer.cornerRadius = 0
        logSegmentedControl.layer.borderWidth = 0.0
        UISegmentedControl.appearance().tintColor = .clear
        logSegmentedControl.addTarget(self, action: #selector(onSegmentChange), for: .valueChanged)
        
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
    }
    
    //to configure views when they reappear
    override func viewWillAppear(_ animated: Bool) {
        onSegmentChange()
    }
    
    //segmentedControl methods
    @objc func onSegmentChange() {
        if logSegmentedControl.selectedSegmentIndex == 0 {
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
                    logSegmentedControl.selectedSegmentIndex = 0
                } else if lastContentOffset < scrollView.contentOffset.x && scrollView.contentOffset.x < 300 {
                    mainScrollView.setContentOffset(CGPoint(x: scrollWidth, y: 0), animated: true)
                    stickScrollView.setContentOffset(CGPoint(x: -segmentWidth/2, y: 0), animated: true)
                    logSegmentedControl.selectedSegmentIndex = 1
                    
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
        if (emailField.text ?? "") != "" &&
            (passwordField.text ?? "") != "" {
            authorizationAction(mail:emailField.text ?? "", password:passwordField.text ?? "")
        } else {
            showErrorWindow(errorMessage: Constants.MESSAGE.ERROR_NOT_ALL_FILLED)
        }
    }
    
    @IBAction func onRegByPhone(_ sender: Any) {
        if !(phoneField.text?.isEmpty ?? true) {
            authByPhoneAction(phone: phoneField.text ?? "")
        }
    }
    
    func authByPhoneAction(phone:String) {
        self.showActivityIndicator(loadingView: loadingView, spinner: spinner)
        AuthorizationService.current.authorizationUserByPhone(phone: phone) { (answerDic, error) in
            if(error != nil) {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
            if let answerDic = answerDic {
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(self.phoneField.text, forKey: "mobilePhone")
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.performSegue(withIdentifier: "showSmsVC", sender: answerDic["object"])
                }
            }
        }
    }
    
    func authorizationAction(mail:String, password:String) {
        self.showActivityIndicator(loadingView: loadingView, spinner: self.spinner)
        AuthorizationService.current.authorizationUser(mail: mail, password: password)
        { (generalAnswer, error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
            if let generalAnswer = generalAnswer {
                DispatchQueue.main.async {
                     self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                    UserDefaults.standard.set(generalAnswer.accessToken, forKey: "token")
                    UserDefaults.standard.set(true, forKey: "auth")
                    UserDefaults.standard.set(mail, forKey: "email")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "showMain", sender: self)
                    self.setNewRootController(nameController: "MainVC")
                }
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSmsVC" {
            let vc = segue.destination as? SmsVC
            vc?.code = sender as? String
        }
    }
}
