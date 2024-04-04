//
//  ProfileViewController.swift
//  pointercrate
//
//  Created by samara on 3/22/24.
//

import UIKit

class ProfileViewController: UIViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    fileprivate func setupViews() {
		self.view.backgroundColor = .systemBackground
    }
    
    fileprivate func setupNavigation() {
        self.navigationItem.title = nil
        let n = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = n
    }
    
    @objc func openSettings() {
        let svc = SettingsViewController()
		svc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(svc, animated: true)
    }
}
