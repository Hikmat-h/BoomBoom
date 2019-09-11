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

    private var viewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 4.0, right: 16.0)
        bar.fadesContentEdges = false
        bar.spacing = 16.0
        bar.tintColor = #colorLiteral(red: 0.9803921569, green: 0.2274509804, blue: 0.4078431373, alpha: 1)
        
        bar.backgroundView.style = .flat(color: #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1))
        bar.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        bar.buttons.customize { (button) in
            button.selectedTintColor = #colorLiteral(red: 0.9803921569, green: 0.2274509804, blue: 0.4078431373, alpha: 1)
            button.tintColor = #colorLiteral(red: 0.9803921569, green: 0.2274509804, blue: 0.4078431373, alpha: 1)
        }
        // Add to view
        addBar(bar, dataSource: self, at: .bottom)
        
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
        let item = TMBarItem(image: UIImage(named: "menu_\(index)")!, badgeValue: "2")
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
