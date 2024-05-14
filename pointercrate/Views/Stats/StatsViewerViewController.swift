//
//  ProfileViewController.swift
//  pointercrate
//
//  Created by samara on 3/22/24.
//

import UIKit

class StatsViewerViewController: UIViewController {

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
    }
}
