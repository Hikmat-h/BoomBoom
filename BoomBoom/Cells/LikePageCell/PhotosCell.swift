//
//  PhotosCellTableViewCell.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/19/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosCell: UITableViewCell, UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var nameAndAgelbl: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var token:String = UserDefaults.standard.value(forKey: "token") as! String
    let language:String = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
    
    var photos:[Photo] = []
    var myFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    let baseURL = Constants.HTTP.PATH_URL
    let gray = #colorLiteral(red: 0.2745098039, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
    let red = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
    var currentPhotoIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let like = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        likeBtn.tintColor = #colorLiteral(red: 0.2745098039, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        likeBtn.setImage(like, for: .normal)

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    override func prepareForReuse() {
        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
    }
    
    //used to update scrollView from parent VC
    func updatePageScroller() {
        configurePageControl()
        for (index, photo) in photos.enumerated() {

            myFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            myFrame.size = self.scrollView.frame.size

            let imageView = UIImageView(frame: myFrame)
            
            let url = baseURL + "/" + photo.pathURL
            imageView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            self.scrollView.addSubview(imageView)
            
        }
        
        if (photos.count > 0){
            let width = CGFloat(self.scrollView.frame.size.width) * CGFloat(photos.count)
            self.scrollView.contentSize = CGSize(width:width, height: self.scrollView.frame.size.height)
        } else {
            let width = CGFloat(self.scrollView.frame.size.width)
            self.scrollView.contentSize = CGSize(width:width, height: self.scrollView.frame.size.height)
            let tempFrame = CGRect(origin: .zero, size: scrollView.frame.size)
            let imageView = UIImageView(frame: tempFrame)
            imageView.image = UIImage(named: "default_ava2")
            imageView.backgroundColor = .gray
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            self.scrollView.addSubview(imageView)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLike(_ sender: Any) {
        if currentPhotoIndex < photos.count {
            likePhoto(token:token, lang: language, photoID: photos[currentPhotoIndex].id)
        }
    }
    
    func updateLikeBtnState(){
        guard photos.count>0 else { return }
        if photos[currentPhotoIndex].ilike ?? false {
            likeBtn.tintColor = red
        } else {
            likeBtn.tintColor = gray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    //MARK: - page control
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = photos.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
    }

    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        currentPhotoIndex = Int(pageNumber)
        updateLikeBtnState()
    }
    
    //MARK: - api call
    func likePhoto(token:String, lang:String, photoID:Int){
        NewsService.current.likePhoto(token: token, lang: lang, photoId: photoID) { (photo, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.photos[self.currentPhotoIndex].ilike?.toggle()
                    self.updateLikeBtnState()
                }
            }
        }
    }
}
