//
//  UIView.swift
//  pointercrate
//
//  Created by samara on 3/21/24.
//

import UIKit

class GradientBlurImageView: UIImageView {
	private var variableBlurView: UIVariableBlurView?

	override func layoutSubviews() {
		super.layoutSubviews()
		if variableBlurView == nil {
			setupVariableBlurView()
		}
	}

	private func setupVariableBlurView() {
		variableBlurView = UIVariableBlurView(frame: bounds)
		guard let variableBlurView = variableBlurView else { return }
		variableBlurView.translatesAutoresizingMaskIntoConstraints = false

		let gradientMask = VariableBlurViewConstants.defaultGradientMask
		variableBlurView.gradientMask = gradientMask

		addSubview(variableBlurView)
		sendSubviewToBack(variableBlurView)

		NSLayoutConstraint.deactivate(variableBlurView.constraints)

		let blurViewHeight = bounds.height * 0.5
		NSLayoutConstraint.activate([
			variableBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
			variableBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
			variableBlurView.heightAnchor.constraint(equalToConstant: blurViewHeight),
			variableBlurView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])

		variableBlurView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
	}
}
