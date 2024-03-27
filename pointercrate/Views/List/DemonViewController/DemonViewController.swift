//
//  DemonViewController.swift
//  pointercrate
//
//  Created by samara on 3/26/24.
//

import UIKit

class DemonViewController: UIViewController {
    var demonID: Int? {
        didSet {
            if let demonID = demonID {
                print("Demon ID set to: \(demonID)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let backButtonImage = UIImage(systemName: "chevron.left.circle.fill", withConfiguration: symbolConfiguration)?.withTintColor(.white, renderingMode: .alwaysOriginal)

        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(goToRootViewController))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func goToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
