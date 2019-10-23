//
//  SearchResultVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/17/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import PeekPop
import SDWebImage

class SearchResultVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, PeekPopPreviewingDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var peekPop: PeekPop?
    let cellWidth = UIScreen.main.bounds.size.width/3
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    //vars to send to server
    var sex:String = "all"
    var minAge:Int = 0
    var maxAge:Int = 1000
    var minHeight: Int = 0
    var maxHeight: Int = 1000
    var minWeight: Int = 0
    var maxWeight: Int = 1000
    var countryID: Int = -1
    var cityID:Int = -1
    
    var friendShip = true
    var travel = true
    var dating = true
    var evening = true
    var sponsor = true
    
    //data models
    var accounts:[SearchResult] = []
    
    //for 3d touch
    var chosenIndex = -1
    
    //static vars
    var token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    let baseURL = Constants.HTTP.PATH_URL
    
    var pageNo:CLong=0
    var isLastPage:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView)
        
        getAccounts(token: token, lang: language, yearFrom: minAge, yearTo: maxAge, sex: sex, heightFrom: minHeight, heightTo: maxHeight, weightFrom: minWeight, weightTo: maxWeight, pdSponsorship: sponsor, pdSpendEvening: evening, pdPeriodicMeetings: dating, pdTravels: travel, pdFriendshipCommunication: friendShip, countryId: countryID != -1 ? countryID : nil, cityId: cityID != -1 ? cityID : nil, page: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - CollectionView dataSource and delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.NEWS_PHOTO_CELL, for: indexPath) as! NewsPhotoCell
        cell.photoImgView.frame.size = CGSize(width: cellWidth+1, height: cellWidth+1)
        
        if accounts[indexPath.row].photos.count>0 {
            let url = baseURL + "/" + (accounts[indexPath.row].photos[0].pathURLPreview)
            cell.photoImgView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
        } else {
            cell.photoImgView.image = UIImage(named: "default_ava")
        }
        return cell
    }
    
    //selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "LikePhotoVC") as? LikePhotoVC else { return }
        detailVC.userID = accounts[indexPath.row].id
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        show(detailVC, sender: self)
    }
    
    //load new photos
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == accounts.count - 1 {
            if !isLastPage{
                pageNo = pageNo + 1
                getAccounts(token: token, lang: language, yearFrom: minAge, yearTo: maxAge, sex: sex, heightFrom: minHeight, heightTo: maxHeight, weightFrom: minWeight, weightTo: maxWeight, pdSponsorship: sponsor, pdSpendEvening: evening, pdPeriodicMeetings: dating, pdTravels: travel, pdFriendshipCommunication: friendShip, countryId: countryID != -1 ? countryID : nil, cityId: cityID != -1 ? cityID : nil, page: pageNo)
            }
        }
    }
    
    //for cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth-1, height: cellWidth-1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    //MARK: - 3d Touch
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
        chosenIndex = indexPath.row
        guard let cell = collectionView?.cellForItem(at: indexPath) as? NewsPhotoCell else { return nil }
        guard let preview = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as? PreviewVC else { return nil }
        previewingContext.sourceRect = cell.frame
        preview.img = cell.photoImgView.image
        
        return preview
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
         guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "LikePhotoVC") as? LikePhotoVC else { return }
        detailVC.userID = accounts[chosenIndex].id
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        show(detailVC, sender: self)
    }
    
    //MARK: - API Call
    func getAccounts(token:String,
    lang:String,
    yearFrom:Int,
    yearTo:Int,
    sex:String,
    heightFrom:Int,
    heightTo:Int,
    weightFrom:Int,
    weightTo:Int,
    pdSponsorship:Bool,
    pdSpendEvening:Bool,
    pdPeriodicMeetings:Bool,
    pdTravels:Bool,
    pdFriendshipCommunication:Bool,
    countryId:Int?,
    cityId:Int?,
    page:Int){
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        SearchService.current.searchAccounts(token: token, lang: lang, yearFrom: yearFrom, yearTo: yearTo, sex: sex, heightFrom: heightFrom, heightTo: heightTo, weightFrom: weightFrom, weightTo: weightTo, pdSponsorship: pdSponsorship, pdSpendEvening: pdSpendEvening, pdPeriodicMeetings: pdPeriodicMeetings, pdTravels: pdTravels, pdFriendshipCommunication: pdFriendshipCommunication, countryId: countryId, cityId: cityId, page: page) { (results, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if error == nil {
                    if ((results?.count ?? 0) > 0){
                        self.isLastPage = false
                        self.accounts = self.accounts + (results ?? [])
                        self.collectionView.reloadData()
                    } else {
                        self.isLastPage = true
                    }
                } else if error?.code == 401 {
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "showAuth", sender: self)
                    self.setNewRootController(nameController: "AuthorizationVC")
                } else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }

}
