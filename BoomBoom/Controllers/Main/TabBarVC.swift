//
//  TabBarVC.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/11/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class TabBarVC: TabmanViewController {

    @IBOutlet weak var tabBarView: UIView!
    private var viewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nav bar
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        navigationItem.hidesBackButton = true
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let personalNewsVC = storyBoard.instantiateViewController(withIdentifier: "PersonalNewsVC")
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatVC")
        let newsVC = storyBoard.instantiateViewController(withIdentifier: "NewsVC")
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC")
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC")
        viewControllers.append(personalNewsVC)
        viewControllers.append(chatVC)
        viewControllers.append(newsVC)
        viewControllers.append(searchVC)
        viewControllers.append(profileVC)
        
        self.dataSource = self
        
        // Create bar
        let bar = TMBar.TabBar()
        bar.layout.transitionStyle = .none // Customize
        bar.frame = tabBarView.frame
        bar.layout.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        bar.fadesContentEdges = false
        bar.tintColor = #colorLiteral(red: 0.9803921569, green: 0.2274509804, blue: 0.4078431373, alpha: 1)

        bar.backgroundView.style = .clear
        bar.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        bar.buttons.customize { (button) in
            
            button.selectedTintColor = #colorLiteral(red: 0.9803921569, green: 0.2274509804, blue: 0.4078431373, alpha: 1)
            button.tintColor = .white
        }
        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        
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

extension TabBarVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let image = UIImage(named:
            "menu_\(index)")!.withRenderingMode(.alwaysTemplate)
        let item = TMBarItem(image:image)
        item.title = ""
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
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}
