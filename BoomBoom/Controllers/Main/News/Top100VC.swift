//
//  Top100VC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/17/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import PeekPop
import SDWebImage

class Top100VC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, PeekPopPreviewingDelegate, UIScrollViewDelegate {

    var peekPop: PeekPop?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    var photos: [Top100Account] = []
    var chosenIndex = -1
    let cellWidth = UIScreen.main.bounds.size.width/3
    //static vars
    var token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    let baseURL = Constants.HTTP.PATH_URL
    
    var refreshControl: UIRefreshControl?
    
    var pageNo:CLong=0
    var isLastPage:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //nav bar
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        let info = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = info
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView)
        
        //настраиваем refreshControl
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загрузка ...", attributes: attributes)
        
        refreshControl?.tintColor = UIColor.white
        //        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl!)
        
        getTop100(token: token, lang: language, page: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - refreshing
    var canRefresh = true
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -100 {
            
            if canRefresh && !self.refreshControl!.isRefreshing {
                
                self.canRefresh = false
                self.refreshControl!.beginRefreshing()
                
                self.refresh(sender: self)
            }
        }else if scrollView.contentOffset.y >= 0 {
            
            self.canRefresh = true
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        photos.removeAll()
        
        collectionView?.reloadData()
        pageNo = 0
        getTop100(token: token, lang: language, page: 0)
    }
    
    @objc func showInfo(){
        let alert = UIAlertController(title: "", message: "This is top 100 photos of the day", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Оk", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - CollectionView dataSource and delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NAME_CELL.NEWS_PHOTO_CELL, for: indexPath) as! NewsPhotoCell
        cell.photoImgView.frame.size = CGSize(width: cellWidth+1, height: cellWidth+1)
        let url = baseURL + "/" + (photos[indexPath.row].pathURLPreview )
        cell.photoImgView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
        return cell
    }
    
    //selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "LikePhotoVC") as? LikePhotoVC else { return }
        detailVC.userID = photos[indexPath.row].accountID
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        show(detailVC, sender: self)
    }
    
    //load new photos
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == photos.count - 1 {
            if !isLastPage{
                pageNo = pageNo + 1
                getTop100(token: token, lang: language, page: pageNo)
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
        detailVC.userID = photos[chosenIndex].accountID
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        show(detailVC, sender: self)
    }
    
    //MARK: - API call
    
    func getTop100(token:String, lang:String, page:Int){
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        NewsService.current.getTop100Photo(token: token, lang: lang, page: page) { (photoList, error) in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                if error == nil {
                    if ((photoList?.count ?? 0) > 0){
                        self.isLastPage = false
                        self.photos = self.photos + (photoList ?? [])
                        self.collectionView.reloadData()
                    } else {
                        self.isLastPage = true
                    }
                } else {
                    self.showErrorWindow(errorMessage: error?.domain ?? "")
                }
            }
        }
    }
    
}
