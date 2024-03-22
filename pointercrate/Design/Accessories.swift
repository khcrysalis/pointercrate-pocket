//
//  Accessories.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit

class Append {
    func accessoryIcon(to cell: UITableViewCell, with symbolName: String, tintColor: UIColor = .tertiaryLabel, renderingMode: UIImage.RenderingMode = .alwaysOriginal) {
        if let image = UIImage(systemName: symbolName)?.withTintColor(tintColor, renderingMode: renderingMode) {
            let imageView = UIImageView(image: image)
            cell.accessoryView = imageView
        } else {
            cell.accessoryView = nil
        }
    }
}
