//
//  TabbarController.swift
//  pointercreate-ios
//
//  Created by samara on 3/20/24.
//

import UIKit
import SwiftUI

class TabbarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTabs()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if Preferences.isOnboardingActive {
			self.presentOnboarding()
		}
	}
	
	private func setupTabs() {
		let list = self.createNavigation(with: "Demon List", and: UIImage(named: "Demon List"), vc: ListViewController())
		let stats = self.createNavigation(with: "Stats", and: UIImage(named: "Stats"), vc: StatsViewerViewController())
		//let profile = self.createNavigation(with: "Profile", and: UIImage(named: "Profile"), vc: ProfileViewController())
		let settings = self.createNavigation(with: "Settings", and: UIImage(systemName: "gearshape.circle.fill"), vc: SettingsViewController())

		self.setViewControllers([
			list,
			stats,
			//profile,
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
	
	private func presentOnboarding() {
		let hostingController = UIHostingController(rootView: OnboardingViewController())
		
		hostingController.modalPresentationStyle = .fullScreen
		self.present(hostingController, animated: false)
		
		hostingController.view.alpha = 0
		DispatchQueue.main.async {
			UIView.animate(withDuration: 1) {
				hostingController.view.alpha = 1
			}
		}
	}


}
