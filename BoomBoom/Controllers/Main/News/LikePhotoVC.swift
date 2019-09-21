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
//        //about view
//        let aboutView = UIView(frame: CGRect(x: 15, y: viewToResize.frame.height-100, width: screenSize.width-30, height: 231))
//        aboutView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
//
//        let title = UILabel(frame: CGRect(x: 16, y: 20, width: 153, height: 28))
//        title.text = "Обо мне"
//        title.font = UIFont(name: "Roboto-medium", size: 20)
//        title.textColor = .white
//
//        let view = UILabel()
//        view.frame = CGRect(x: 17, y: 65, width: aboutView.frame.width - 34, height: 51)
//        view.backgroundColor = .clear
//        view.textColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
//        view.font = UIFont(name: "Roboto", size: 14)
//        view.numberOfLines = 0
//        view.lineBreakMode = .byWordWrapping
//        view.text = "Родилась и выросла в деревне. Люблю пасти скот, бегать по полю голышом. Увлекаюсь изотерикой и черной магией. Я гетеро, 60 кг, 170 см, плотного телосложения, третий размер груди, блондинка с голубыми глазами."
//
//        let view2 = UILabel()
//        view2.frame = CGRect(x: 17, y: 120, width: aboutView.frame.width-34, height: 94)
//        view2.backgroundColor = .clear
//        view2.textColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
//        view2.font = UIFont(name: "Roboto", size: 14)
//        view2.numberOfLines = 0
//        view2.lineBreakMode = .byWordWrapping
//        view2.text = "Я гетеро, 60 кг, 170 см, плотного телосложения, третий размер груди, блондинка с голубыми глазами."
//
//
//
//        aboutView.addSubview(title)
//        aboutView.addSubview(view)
//        aboutView.addSubview(view2)
//        contentView.addSubview(aboutView)
    }
    
    @objc func onPhone() {
        print("wanna get phone number?")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "photosCell") as! PhotosCell
            return cell
        } else if indexPath.row>0 && indexPath.row<5 {
            cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoCell
            return cell
        } else if indexPath.row == 5 {
            cell = tableView.dequeueReusableCell(withIdentifier: "verificationCell") as! VerificationCell
            return cell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "actionsCell") as! ActionsCell
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
