//
//  ChatPhotoVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 11/13/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
import Alamofire

class ChatPhotoVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var url = ""
    var isVideo = false
    var presented = false
    let token = UserDefaults.standard.value(forKey: "token") ?? ""

    var player: AVPlayer!
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    private var playerItemContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isVideo {
            imageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            downloadVideo(fromURL: url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //automatically dismiss after finishing video play
        if presented {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func downloadVideo(fromURL: String){
        showActivityIndicator(loadingView: loadingView, spinner: spinner)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let videoName = fromURL.components(separatedBy: "id=")
        if !doesFileExist(withName: videoName[1]) {
            Alamofire.request(fromURL, headers: headers).downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
            }).responseData{ (response) in
                if let data = response.result.value {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let videoURL = documentsURL.appendingPathComponent("\(videoName[1]).mp4")
                    do {
                        try data.write(to: videoURL)
                        } catch {
                        print("Something went wrong!")
                        return
                    }
                    self.player = AVPlayer(url: videoURL as URL)
                    let vc = AVPlayerViewController()
                    vc.player = self.player
                    DispatchQueue.main.async {
                        self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                        self.presented = true
                        self.present(vc, animated: true) { vc.player?.play() }
                    }
                }
            }
        } else {
            //load from documents directory
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let videoURL = documentsURL.appendingPathComponent("\(videoName[1]).mp4")
            self.player = AVPlayer(url: videoURL as URL)
            let vc = AVPlayerViewController()
            vc.player = self.player
            DispatchQueue.main.async {
                self.hideActivityIndicator(loadingView: self.loadingView, spinner: self.spinner)
                self.presented = true
                self.present(vc, animated: true) { vc.player?.play() }
            }
        }
    }
    
    //checks if file is downladed to documents dir
    func doesFileExist(withName:String)->Bool{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(withName).mp4") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
