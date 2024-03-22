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
        view.backgroundColor = .secondarySystemGroupedBackground
    }
    
    fileprivate func setupNavigation() {
        self.navigationItem.title = nil
        let n = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = n
    }
    
    @objc func openSettings() {
        let svc = SettingsViewController()
        navigationController?.pushViewController(svc, animated: true)
    }
}
