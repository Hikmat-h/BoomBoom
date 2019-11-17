//
//  ChatMediaManager.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 11/6/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import Alamofire

class ChatMediaManager {
    
    let pathURL:String =  Constants.HTTP.PATH_URL
    var headers_urlencoded: HTTPHeaders = ["Content-Type":"multipart/form-data"]
       
    static let current = ChatMediaManager()
    private init(){}
    
    func sendPhoto(token:String, lang:String, image:UIImage, accountToId:Int, name:String, completion: @escaping (SentPhotoAnswer?, NSError?)->Void) {
        let imgData = image.jpegData(compressionQuality: 1.0)!
        if let url = URL(string: "\(pathURL)/chat/photo/set?accountToId=\(accountToId)&name=\(name)") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            Alamofire.upload( multipartFormData: { (multiPartFormData) in
                multiPartFormData.append(imgData, withName: name, fileName: "file.jpg", mimeType: "image/jpg")
            }, to: url, headers: headers_urlencoded) { (result) in
                switch result {
                case .success(let upload, _, _):
                    //progress block
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    //success block
                    upload.responseJSON { response in
                        guard let data = response.data else { return }
                        let detail = try? JSONDecoder().decode(SentPhotoAnswer.self, from: data)
                        completion(detail, nil)
                    }

                case .failure(let encodingError):
                    print(encodingError)
                    completion(nil, encodingError as NSError)
                }
            }
        }
    }
    
    ///chat/video/set
    func sendVideo(token:String, lang:String, videoData: Data, accountToId: Int, name:String, completion: @escaping (SentVideoAnswer?, NSError?)->Void) {
        if let url = URL(string: "\(pathURL)/chat/video/set?accountToId=\(accountToId)&name=\(name)") {
            headers_urlencoded["Accept-Language"] = lang
            headers_urlencoded["Authorization"] = "Bearer \(token)"
            Alamofire.upload( multipartFormData: { (multiPartFormData) in
                multiPartFormData.append(videoData, withName: name, fileName: "video.mp4", mimeType: "video/mp4")
            }, to: url, headers: headers_urlencoded) { (result) in
                switch result {
                case .success(let upload, _, _):
                    //progress block
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    //success block
                    upload.responseJSON { response in
                        guard let data = response.data else { return }
                        let detail = try? JSONDecoder().decode(SentVideoAnswer.self, from: data)
                        completion(detail, nil)
                    }

                case .failure(let encodingError):
                    print(encodingError)
                    completion(nil, encodingError as NSError)
                }
            }
        }
    }
    
}
