//
//  ProfileVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blanketBtn: UIButton!
    @IBOutlet weak var subscriptionBtn: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        navigationItem.hidesBackButton = true
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        blanketBtn = Utils.current.setButtonStyle(btn: blanketBtn, cornerRadius: 15)
        subscriptionBtn = Utils.current.setButtonStyle(btn: subscriptionBtn, cornerRadius: 15)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1700)
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1800)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //nav bar
        self.navigationController?.navigationBar.barTintColor = .black
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.PROFILE_PHOTO_CELL, for: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "takeUpSegue" {
            let vc = segue.destination as? ExtendSubscriptionVC
            vc?.info = "Анкета будет поднята наверх в течении 5 минут!"
            vc?.up = true
        } else {
            let vc = segue.destination as? ExtendSubscriptionVC
            vc?.info = "Оформив подписку, вы получаете возможность общения в чатах с другими пользователями."
            vc?.up = false
        }
    }

}
