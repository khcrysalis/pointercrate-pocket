//
//  AppDelegate.swift
//  pointercrate
//
//  Created by samara on 3/20/24.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = TabbarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        
        DispatchQueue.main.async {
            self.window!.tintColor = .systemTeal
            self.window!.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: Preferences.preferredInterfaceStyle) ?? .unspecified
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

