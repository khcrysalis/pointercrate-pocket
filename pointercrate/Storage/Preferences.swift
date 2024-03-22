//
//  Preferences.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit

enum Preferences {
    @Storage(key: "userIntefaceStyle", defaultValue: UIUserInterfaceStyle.unspecified.rawValue)
    static var preferredInterfaceStyle: Int
}
// MARK: - Callbacks
fileprivate extension Preferences {

}
