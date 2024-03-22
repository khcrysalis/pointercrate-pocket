//
//  UIView.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit

extension UIView {
    func createGradientBlur() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor
        ]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0 , y: 0.7)
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        effectView.frame = bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.layer.mask = gradientLayer
        
        addSubview(effectView)
    }
}
