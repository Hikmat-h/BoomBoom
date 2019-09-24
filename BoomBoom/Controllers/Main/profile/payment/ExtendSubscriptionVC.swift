//
//  ExtendSubscriptionVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/23/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ExtendSubscriptionVC: TabmanViewController {

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var tabBarView: UIView!
    var viewControllers: [PageRateVC] = []
    var titles: [String] = ["GOOGLE PLAY", "ТЕЛЕФОН", "КРЕДИТКА", "QIWI"]
    var info:String = ""
    var up: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Продление подписки"
        
        self.infoTextView.text = info
        
        for _ in 1...4 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageRateVC") as? PageRateVC
            vc?.up = up
            viewControllers.append(vc!)
        }
        
         self.dataSource = self
        // Create bar
        let bar = TMBar.TabBar()
        bar.layout.transitionStyle = .none // Customize
        bar.frame = tabBarView.frame
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0)
        bar.fadesContentEdges = false
        bar.indicator.tintColor = #colorLiteral(red: 0.4509803922, green: 0.7960784314, blue: 0.9019607843, alpha: 1)
        
        bar.backgroundView.style = .clear
        bar.backgroundColor = .clear
        bar.buttons.customize { (button) in
            
            button.selectedTintColor = #colorLiteral(red: 0.4509803922, green: 0.7960784314, blue: 0.9019607843, alpha: 1)
            button.tintColor = .white
        }
        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: .none))
        
    }

}

extension ExtendSubscriptionVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let image = UIImage(named: "pay_\(index)")?.withRenderingMode(.alwaysTemplate)
        let title = titles[index]
        let item = TMBarItem(title: title, image: image!)
        
        return item
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
