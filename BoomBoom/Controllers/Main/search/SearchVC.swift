//
//  SearchVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet var radioButtons: [UIButton]!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var fView: UIView!
    @IBOutlet weak var coupleView: UIView!
    @IBOutlet weak var allView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mTap = UITapGestureRecognizer(target: self, action: #selector(mTapped(_:)))
        mView.addGestureRecognizer(mTap)
        let fTap = UITapGestureRecognizer(target: self, action: #selector(fTapped(_:)))
        fView.addGestureRecognizer(fTap)
        let cTap = UITapGestureRecognizer(target: self, action: #selector(cTapped(_:)))
        coupleView.addGestureRecognizer(cTap)
        let aTap = UITapGestureRecognizer(target: self, action: #selector(aTapped(_:)))
        allView.addGestureRecognizer(aTap)
    }
    
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
    //    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
