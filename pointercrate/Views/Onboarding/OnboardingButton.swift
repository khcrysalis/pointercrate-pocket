//
//  OnboardingButton.swift
//  pointercrate
//
//  Created by samara on 3/30/24.
//

import Foundation
import SwiftUI

struct OnboardingButton: ButtonStyle {
	var textColor: Color
	var shadowColor: Color
	var gradientColors: [Color]
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12))
			.frame(maxWidth: .infinity)
			.foregroundColor(textColor)
			.background(
				LinearGradient(
					gradient: Gradient(colors: gradientColors),
					startPoint: .top,
					endPoint: .bottom
				)
			)
			.clipShape(RoundedRectangle(cornerRadius: 16))
			.shadow(color: shadowColor, radius: 0.5)
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
			.onChange(of: configuration.isPressed) { isPressed in
				if isPressed {
					withAnimation(.easeInOut(duration: 0.1)) {
						let generator = UIImpactFeedbackGenerator(style: .medium)
						generator.impactOccurred()
					}
				}
			}
	}
}
