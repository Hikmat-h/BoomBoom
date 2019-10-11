//
//  PhotoEditVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 10/7/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import CropViewController
import HorizontalDial
import IGRPhotoTweaks

class PhotoEditVC: IGRPhotoTweakViewController {
    
    @IBOutlet weak var horizontalDial: HorizontalDial! {
        didSet {
            self.horizontalDial?.migneticOption = .none
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        horizontalDial.delegate = self
        
//        self.photoView.minimumZoomScale = 1.0;
//        self.photoView.maximumZoomScale = 10.0;
        self.setCropAspectRect(aspect: "3:4")
        self.lockAspectRatio(true)
    }
    
    // MARK: - Rotation
       
//   override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//       super.willTransition(to: newCollection, with: coordinator)
//
//       coordinator.animate(alongsideTransition: { (context) in
//           self.view.layoutIfNeeded()
//       }) { (context) in
//           //
//       }
//   }
    
    @IBAction func onReset(_ sender: Any) {
        self.horizontalDial.value = 0.0
    }
    
    @IBAction func onDone(_ sender: Any) {
        
    }
}
    // MARK: - horizontalDial delegate
extension PhotoEditVC: HorizontalDialDelegate {
    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
        let degrees = horizontalDial.value
        let radians = IGRRadianAngle.toRadians(CGFloat(degrees))
        self.changedAngle(value: radians)
    }

    func horizontalDialDidEndScroll(_ horizontalDial: HorizontalDial) {
        self.stopChangeAngle()
    }
}
