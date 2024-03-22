//
//  TabbarController.swift
//  pointercreate-ios
//
//  Created by samara on 3/20/24.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let list = self.createNavigation(with: "Demon List", and: UIImage(named: "Demon List"), vc: ListViewController())
        let changes = self.createNavigation(with: "History", and: UIImage(named: "History"), vc: ChangesViewController())
        let stats = self.createNavigation(with: "Stats", and: UIImage(named: "Stats"), vc: UIViewController())
        let settings = self.createNavigation(with: "Profile", and: UIImage(named: "Profile"), vc: ProfileViewController())

        self.setViewControllers([
            list,
            changes,
            stats,
            settings
        ], animated: false)
    }
    
    private func createNavigation(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        
        return nav
    }
}
