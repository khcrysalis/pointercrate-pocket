//
//  Preferences.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit

enum Preferences {
    @Storage(key: "Pointercrate.userIntefacerStyle", defaultValue: UIUserInterfaceStyle.unspecified.rawValue)
    static var preferredInterfaceStyle: Int
	
	@Storage(key: "Pointercrate.OnboardingActive", defaultValue: true)
	static var isOnboardingActive: Bool
}
// MARK: - Callbacks
fileprivate extension Preferences {

}
