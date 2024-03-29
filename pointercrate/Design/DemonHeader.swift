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
	
	func updateTitle(_ title: String) {
		titleLabel.text = title
		titleLabel.sizeToFit()
	}
	
	func updateSubtitle(_ subtitle: String) {
		subLabel.text = subtitle
		subLabel.sizeToFit()
	}

    init(view: UIView, height initial: CGFloat) {
        self.view = view
        initialHeight = initial

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
		titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()

        subLabel = UILabel()
		subLabel.font = .systemFont(ofSize: 15, weight: .regular)
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

		let leftMargin: CGFloat = 16
		let bottomMargin: CGFloat = 20

		titleLabel.sizeToFit()
		subLabel.sizeToFit()

		let titleLabelHeight = titleLabel.frame.size.height
		let subLabelHeight = subLabel.frame.size.height

		let xPosition: CGFloat = leftMargin
		let yPosition = view.frame.height - bottomMargin - titleLabelHeight - subLabelHeight

		titleLabel.frame.origin = CGPoint(x: xPosition, y: yPosition)
		subLabel.frame.origin = CGPoint(x: xPosition, y: yPosition + titleLabelHeight + 4)
	}
}
