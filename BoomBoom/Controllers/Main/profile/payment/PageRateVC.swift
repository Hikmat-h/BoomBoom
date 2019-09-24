//
//  PageRateVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/23/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit

class PageRateVC: UIViewController {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var upNewView: UIView!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var monthSwitch: UISwitch!
    @IBOutlet weak var weekSwitch: UISwitch!
    @IBOutlet weak var daySwitch: UISwitch!
    
    var up:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.upView.isHidden = !up
        self.upNewView.isHidden = !up
        self.dayView.isHidden = up
        self.weekView.isHidden = up
        self.monthView.isHidden = up
        let blue = #colorLiteral(red: 0.4509803922, green: 0.7960784314, blue: 0.9019607843, alpha: 1)
        daySwitch.tintColor = blue
        monthSwitch.tintColor = blue
        weekSwitch.tintColor = blue
        payBtn = Utils.current.setButtonStyle(btn: payBtn)
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
