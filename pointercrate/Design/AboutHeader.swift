//
//  AboutHeader.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import Foundation
import UIKit

class HeaderController {
    let view: UIView
    let initialHeight: CGFloat
    weak var scrollView: UIScrollView?
    
    private var titleLabel: UILabel!
    private var subLabel: UILabel!
    
    var viewHeight: CGFloat {
        return initialHeight
    }

    init(view: UIView, height initial: CGFloat) {
        self.view = view
        initialHeight = initial
        
        var t = ""
        var s = ""
        
        if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            t = appName
            s = "By Samara"
        }

        titleLabel = UILabel()
        titleLabel.text = t
        titleLabel.font = UIFont(name: "Overdose Sunrise", size: 36)
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()

        subLabel = UILabel()
        subLabel.text = s
        subLabel.font = UIFont(name: "Overdose Sunrise", size: 24)
        subLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        subLabel.numberOfLines = 0
        subLabel.sizeToFit()

        view.addSubview(titleLabel)
        view.addSubview(subLabel)
    }

    func attach(to scrollView: UIScrollView) {
        self.scrollView = scrollView
        
        scrollView.addSubview(view)
        scrollView.contentInset = UIEdgeInsets(top: viewHeight, left: 0, bottom: 0, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -viewHeight)
        
        layoutStickyView()
    }


    func layoutStickyView() {
        guard let scrollView = scrollView else { return }

        var newFrame = CGRect(x: 0, y: -viewHeight, width: scrollView.bounds.width, height: viewHeight)

        if scrollView.contentOffset.y < -viewHeight {
            newFrame.origin.y = scrollView.contentOffset.y
            newFrame.size.height = -scrollView.contentOffset.y
        } else {
            newFrame.origin.y = -viewHeight
            newFrame.size.height = viewHeight
        }

        view.frame = newFrame
        view.layer.zPosition = 1000
        
        // Center labels
        let centerX = view.bounds.midX
        let centerY = view.bounds.midY
        
        let totalHeight = titleLabel.frame.height + subLabel.frame.height
        let verticalOffset = (viewHeight - totalHeight) / 2 - 100
        
        titleLabel.frame.origin.y = centerY - totalHeight / 2 + verticalOffset
        subLabel.frame.origin.y = titleLabel.frame.maxY
        
        titleLabel.center.x = centerX
        subLabel.center.x = centerX
    }

}
