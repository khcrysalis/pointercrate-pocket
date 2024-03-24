//
//  SectionIcons.swift
//  pointercrate
//
//  Created by samara on 3/23/24.
//

import Foundation
import UIKit

class SectionIcons {
    @available(iOS 13.0, *)
    static public func sectionIcon(to cell: UITableViewCell, with symbolName: String, backgroundColor: UIColor) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        guard let symbolImage = UIImage(systemName: symbolName, withConfiguration: symbolConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal) else {
            return
        }

        let imageSize = CGSize(width: 30, height: 30)
        let insetAmount: CGFloat = 3
        let scaledSymbolSize = symbolImage.size.aspectFit(in: imageSize, insetBy: insetAmount)

        let coloredBackgroundImage = UIGraphicsImageRenderer(size: imageSize).image { context in
            backgroundColor.setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: 7).fill()
        }

        let mergedImage = UIGraphicsImageRenderer(size: imageSize).image { context in
            coloredBackgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))
            symbolImage.draw(in: CGRect(
                x: (imageSize.width - scaledSymbolSize.width) / 2,
                y: (imageSize.height - scaledSymbolSize.height) / 2,
                width: scaledSymbolSize.width,
                height: scaledSymbolSize.height
            ))
        }

        cell.imageView?.image = mergedImage
        cell.imageView?.layer.cornerRadius = 7
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
    static public func sectionImage(to cell: UITableViewCell, with originalImage: UIImage) {
        let imageSize = CGSize(width: 50, height: 50)

        let resizedImage = UIGraphicsImageRenderer(size: imageSize).image { context in
            originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
        }

        cell.imageView?.image = resizedImage
        cell.imageView?.layer.cornerRadius = 12
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.borderWidth = 0.7
        cell.imageView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
}

extension CGSize {
    func aspectFit(in boundingSize: CGSize, insetBy insetAmount: CGFloat) -> CGSize {
        let scaledSize = self.aspectFit(in: boundingSize)
        return CGSize(width: scaledSize.width - insetAmount * 2, height: scaledSize.height - insetAmount * 2)
    }

    private func aspectFit(in boundingSize: CGSize) -> CGSize {
        let aspectWidth = boundingSize.width / width
        let aspectHeight = boundingSize.height / height
        let aspectRatio = min(aspectWidth, aspectHeight)

        return CGSize(width: width * aspectRatio, height: height * aspectRatio)
    }
}

