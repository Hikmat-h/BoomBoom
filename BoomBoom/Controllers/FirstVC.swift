//
//  RootViewController.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/25/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    private var current: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.value(forKey: "auth") as Any)
        if let isLoggedIn = UserDefaults.standard.value(forKey: "auth") as? Bool {
            if isLoggedIn {
                performSegue(withIdentifier: "showMain", sender: self)
                setNewRootController(nameController: "MainVC")
            } else {
                performSegue(withIdentifier: "showAuth", sender: self)
                setNewRootController(nameController: "AuthorizationVC")
            }
        } else {
            performSegue(withIdentifier: "showAuth", sender: self)
            setNewRootController(nameController: "AuthorizationVC")
        }
    }
    
    
//    func showLoginScreen() {
//
//        let new = UINavigationController(rootViewController: AuthorizationVC())                               // 1
//        addChild(new)                    // 2
//        new.view.frame = view.bounds                   // 3
//        view.addSubview(new.view)                      // 4
//        new.didMove(toParent: self)      // 5
//        current?.willMove(toParent: nil)  // 6
//        current?.view.removeFromSuperview()          // 7
//        current?.removeFromParent()       // 8
//        current = new                                  // 9
//    }
//
//    func switchToLogout() {
//        let loginViewController = AuthorizationVC()
//        let logoutScreen = UINavigationController(rootViewController: loginViewController)
//        animateDismissTransition(to: logoutScreen)
//    }
//
//    func switchToMainScreen() {
//        let mainViewController = TabBarVC()
//        let new = UINavigationController(rootViewController: mainViewController)
//        animateFadeTransition(to: new)
//    }
//
//    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
//        current?.willMove(toParent: nil)
//        addChild(new)
//
//        transition(from: current!, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
//        }) { completed in
//            self.current?.removeFromParent()
//            new.didMove(toParent: self)
//            self.current = new
//            completion?()  //1
//        }
//    }
//
//    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
//        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
//        current?.willMove(toParent: nil)
//        addChild(new)
//        transition(from: current!, to: new, duration: 0.3, options: [], animations: {
//            new.view.frame = self.view.bounds
//        }) { completed in
//            self.current?.removeFromParent()
//            new.didMove(toParent: self)
//            self.current = new
//            completion?()
//        }
//    }
}
