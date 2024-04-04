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
	
	@CodableStorage(key: "AppTintColor", defaultValue: CodableColor(UIColor(hex: "ff7a83")))
	static var appTintColor: CodableColor
	
	@Storage(key: "Pointercrate.OnboardingActive", defaultValue: true)
	static var isOnboardingActive: Bool
}
// MARK: - Callbacks
fileprivate extension Preferences {

}

struct CodableColor: Codable {
	let red: CGFloat
	let green: CGFloat
	let blue: CGFloat
	let alpha: CGFloat
	
	var uiColor: UIColor {
		return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
	}
	
	init(_ color: UIColor) {
		var _red: CGFloat = 0, _green: CGFloat = 0, _blue: CGFloat = 0, _alpha: CGFloat = 0
		
		color.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha)
		
		self.red = _red
		self.blue = _blue
		self.green = _green
		self.alpha = _alpha
	}
}
