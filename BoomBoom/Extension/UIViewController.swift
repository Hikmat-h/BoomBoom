//
//  UIViewController.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/9/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    // когда пользователь нажимает кнопку Return (Enter) на клавиатуре
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // скрыть фокус с текстового поля (клавиатура исчезнет)
        return true
    }
    
    // скрывает клавиатуру при тапе на экран
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // закрывает контроллер в зависимости от того, как его открыли (модально или через navigation controller)
    func closeController(){
        if presentingViewController is UINavigationController { // если открыли как контроллер без исп. стека
            dismiss(animated: true, completion: nil) // просто скрываем
        }
        else if let controller = navigationController{ // если открыли с navigation controller
            controller.popViewController(animated: true) // удалить из стека контроллеров
        }
        else {
            fatalError("can't close controller")
        }
    }
    
    //показ ошибки
    func showErrorWindow(errorMessage: String) {
        // объект диалогового окна
        let dialogMessage = UIAlertController(title: "Ошибка",
                                              message: errorMessage,
                                              preferredStyle: .actionSheet)
        // создания объектов для действий (ок, отмена)
        // действие ОК
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        // добавить действия в диалоговое окно
        dialogMessage.addAction(ok) // закроется диалоговое окно и вызовется segue
        // показать диалоговое окно
        present(dialogMessage, animated: true, completion: nil)
    }
    
    
    //показ любого сообщения
    func showMessageWindow(title: String, message:String) {
        // объект диалогового окна
        let dialogMessage = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .actionSheet)
        // создания объектов для действий (ок, отмена)
        // действие ОК
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        // добавить действия в диалоговое окно
        dialogMessage.addAction(ok) // закроется диалоговое окно и вызовется segue
        // показать диалоговое окно
        present(dialogMessage, animated: true, completion: nil)
    }
    
    
    //показать индикатор загрузки данных
    func showActivityIndicator(loadingView:UIView, spinner: UIActivityIndicatorView) {
        
        DispatchQueue.main.async {
            
            loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            loadingView.center = self.view.center
            loadingView.backgroundColor = .gray
            loadingView.alpha = 0.7
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            spinner.center = CGPoint(x:loadingView.bounds.size.width / 2, y:loadingView.bounds.size.height / 2)
            
            loadingView.addSubview(spinner)
            self.view.addSubview(loadingView)
            spinner.startAnimating()
        }
    }
    
    //спрятать индикатор загрузки данных
    func hideActivityIndicator(loadingView:UIView, spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            
            spinner.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    //переход на другйо контроллер
    func setNewRootController(nameController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: nameController)
        let navigationController = UINavigationController(rootViewController: newViewController)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = navigationController
    }
    
    
    func showExitButton() {
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysOriginal)
        let addButtonRight = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(tapButton))
        self.navigationItem.rightBarButtonItem = addButtonRight
    }
    
    @objc func tapButton() {
        let alert = UIAlertController(title: "Внимание!", message: "Вы действительно хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.exit()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func exit() {
        //обнуляем аутентификацию
//        AppDelegate.settingsUser.setValue(nil, forKey: Constants.UsersProperties.TOKEN_NAME)
//        AppDelegate.settingsUser.setValue(nil, forKey: Constants.UsersProperties.USER_MAIL)
//        AppDelegate.settingsUser.setValue(false, forKey: Constants.UsersProperties.AUTH)
//        setNewRootController(nameController:Constants.NAME_STORYBOARD.AUTH)
    }
    
    //показать уведомление
    func showAlert(title:String, message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
