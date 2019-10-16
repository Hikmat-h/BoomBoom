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
    
    @IBOutlet weak var scrollView: UIScrollView!
    var photos:[Photo] = []
    var myFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    let baseURL = Constants.HTTP.PATH_URL
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let like = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        likeBtn.tintColor = #colorLiteral(red: 0.2745098039, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        likeBtn.setImage(like, for: .normal)
        
        configurePageControl()

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        print(scrollView.frame as Any)
        
        for (index, photo) in photos.enumerated() {

            myFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            myFrame.size = self.scrollView.frame.size

            let imageView = UIImageView(frame: myFrame)
            let url = baseURL + "/" + photo.pathURL
            imageView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached)
            self.scrollView .addSubview(imageView)
        }

        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLike(_ sender: Any) {
        let gray = #colorLiteral(red: 0.2745098039, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        let red = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
        if (likeBtn.tintColor == gray) {
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
    }
}
