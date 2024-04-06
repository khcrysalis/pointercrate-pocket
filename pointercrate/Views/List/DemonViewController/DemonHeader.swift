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
	
	private var button2secondurl: String!

	private var button1: UIButton!
	private var button2: UIButton!
	private var button3: UIButton!
	private var button4: UIButton!
	
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
	
	func updateButtonsatt(position: String, video: String, maxpoints: String, minpoints: String) {
		button1.setAttributedTitle(createAttributedTitle(primaryText: "Position", secondaryText: position), for: .normal)
		button2secondurl = video
		button3.setAttributedTitle(createAttributedTitle(primaryText: "Max Points", secondaryText: maxpoints), for: .normal)
		button4.setAttributedTitle(createAttributedTitle(primaryText: "Min Points", secondaryText: minpoints), for: .normal)
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
		
		let balls = UIColor.white.withAlphaComponent(0.1)

		button1 = UIButton()
		button1.backgroundColor = balls
		button1.layer.cornerRadius = 9
		button1.titleLabel?.numberOfLines = 0
		button1.titleLabel?.lineBreakMode = .byWordWrapping
		button1.titleLabel?.textAlignment = .center

		button2 = UIButton()
		button2.setAttributedTitle(createAttributedTitle(primaryText: "Video", secondaryText: "▶"), for: .normal)
		button2.backgroundColor = balls
		button2.layer.cornerRadius = 9
		button2.titleLabel?.numberOfLines = 0
		button2.titleLabel?.lineBreakMode = .byWordWrapping
		button2.titleLabel?.textAlignment = .center
		button2.addTarget(self, action: #selector(openURL), for: .touchUpInside)
		
		button3 = UIButton()
		button3.backgroundColor = balls
		button3.layer.cornerRadius = 9
		button3.titleLabel?.numberOfLines = 0
		button3.titleLabel?.lineBreakMode = .byWordWrapping
		button3.titleLabel?.textAlignment = .center
		
		button4 = UIButton()
		button4.backgroundColor = balls
		button4.layer.cornerRadius = 9
		button4.titleLabel?.numberOfLines = 0
		button4.titleLabel?.lineBreakMode = .byWordWrapping
		button4.titleLabel?.textAlignment = .center

		view.addSubview(titleLabel)
		view.addSubview(subLabel)
		view.addSubview(button1)
		view.addSubview(button2)
		view.addSubview(button3)
		view.addSubview(button4)
	}
	
	@objc func openURL() {
		guard let urlString = button2secondurl, let url = URL(string: urlString) else {
			print("Error: button2secondurl is nil or invalid")
			return
		}

		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}

	
	func createAttributedTitle(primaryText: String, secondaryText: String) -> NSAttributedString {
		let smallerFontSize: CGFloat = 15
		let primaryColor = UIColor.white.withAlphaComponent(0.5)
		let secondaryColor = UIColor.white
		
		let lineSpacing: CGFloat = 6
		
		let primaryAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: smallerFontSize - 6),
			NSAttributedString.Key.foregroundColor: primaryColor,
			NSAttributedString.Key.kern: 0.5,
			NSAttributedString.Key.paragraphStyle: {
				let style = NSMutableParagraphStyle()
				style.alignment = .center
				style.lineSpacing = lineSpacing
				return style
			}()
		]
		
		let secondaryAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: smallerFontSize),
			NSAttributedString.Key.foregroundColor: secondaryColor,
			NSAttributedString.Key.paragraphStyle: {
				let style = NSMutableParagraphStyle()
				style.alignment = .center
				style.lineSpacing = lineSpacing
				return style
			}()
		]
		
		let firstLine = NSAttributedString(string: primaryText.uppercased(), attributes: primaryAttributes)
		let secondLine = NSAttributedString(string: "\n" + secondaryText, attributes: secondaryAttributes)
		let combinedString = NSMutableAttributedString(attributedString: firstLine)
		combinedString.append(secondLine)
		return combinedString
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
		let buttonSpacing: CGFloat = 10
		
		titleLabel.sizeToFit()
		subLabel.sizeToFit()
		
		let titleLabelHeight = titleLabel.frame.size.height
		let subLabelHeight = subLabel.frame.size.height
		
		let xPosition: CGFloat = leftMargin
		let yPosition = view.frame.height - bottomMargin - titleLabelHeight - subLabelHeight - 40
		
		titleLabel.frame.origin = CGPoint(x: xPosition, y: yPosition - 30)
		subLabel.frame.origin = CGPoint(x: xPosition, y: yPosition + titleLabelHeight + 4 - 30)
		
		let availableWidth = view.bounds.width - 2 * leftMargin
		let buttonWidth: CGFloat = (availableWidth - 3 * buttonSpacing) / 4    // Divide by 4 for 4 buttons and 3 spacings
		//let buttonWidth: CGFloat = (availableWidth - buttonSpacing) / 2     // 2
		
		let buttonYPosition = yPosition + titleLabelHeight + subLabelHeight + 20 - 20
		
		button1.frame = CGRect(x: leftMargin, y: buttonYPosition, width: buttonWidth, height: 50)
		button2.frame = CGRect(x: button1.frame.maxX + buttonSpacing, y: buttonYPosition, width: buttonWidth, height: 50)
		button3.frame = CGRect(x: button2.frame.maxX + buttonSpacing, y: buttonYPosition, width: buttonWidth, height: 50)
		button4.frame = CGRect(x: button3.frame.maxX + buttonSpacing, y: buttonYPosition, width: buttonWidth, height: 50)
	}


}
