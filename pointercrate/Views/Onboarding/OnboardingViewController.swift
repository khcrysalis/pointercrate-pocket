//
//  OnboardingController.swift
//  pointercrate
//
//  Created by samara on 3/30/24.
//

import SwiftUI
import AVKit

public struct OnboardingViewController: View {
	@Environment(\.dismiss) var dismiss
	@State private var secondStage = false

	private let player: AVPlayer
	
	public init() {
		let url = Bundle.main.url(forResource: "Onboarding", withExtension: "mov")!
		self.player = AVPlayer(url: url)
		self.player.actionAtItemEnd = .none
		NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak player] _ in
			guard let player = player else { return }
			player.seek(to: .zero)
			player.play()
		}
	}
	
	public var body: some View {
		ZStack {
			videoPlayerWithEffects(player: player)
				.edgesIgnoringSafeArea(.all)
			
			VStack {
				if !secondStage {
					Spacer()
					Image("GlyphDemon")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(height: 100)
						.padding(.top, secondStage ? -30 : 0)
						.foregroundColor(.primary)
						.opacity(0.9)
						.scaleEffect(secondStage ? 0.5 : 1.0)
				}
				
				
				Spacer()

				if !secondStage {
					Text("This application is not affiliated with the official Pointercrate demonlist.")
						.font(.footnote)
						.foregroundColor(.gray)
						.multilineTextAlignment(.center)
						.transition(.opacity)
					
					Button(action: {
						withAnimation(.smooth) { secondStage = true }
					}) {
						Text("Get Started").bold().lineLimit(1)
					}
					.buttonStyle(OnboardingButton(textColor: .black, shadowColor: .black, gradientColors: [Color.white, Color.gray]))
					.padding(.vertical, 24)
				} else {
					Text("Submissions")
						.bold()
						.foregroundStyle(.white)
						.multilineTextAlignment(.center)
						.padding(.bottom, 10)
						.font(.largeTitle)
						.transition(.slide)
					
					Text("View player submitted records from all across the globe!")
						.foregroundStyle(.white)
						.font(.headline)
						.multilineTextAlignment(.center)
						.transition(.slide)
					
					imageWithEffects()
						.transition(.slide)
					
					Spacer()
					
					Button(action: {
						Preferences.isOnboardingActive = false
						dismiss()
					}) {
						Text("Lets Go!").bold().lineLimit(1)
					}
					.buttonStyle(OnboardingButton(textColor: .black, shadowColor: .black, gradientColors: [Color.white, Color.gray]))
					.padding(.vertical, 24)
				}
				
				
			}
			.padding()
		}
	}
}


extension OnboardingViewController {
	func imageWithEffects() -> some View {
		return ZStack {
			Image("Acheron")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 350, height: 350)
				.shadow(color: .black, radius: 20)
				.rotation3DEffect(
					.degrees(20),
					axis: (x: 0.4, y: 0, z: 0),
					anchor: .center,
					perspective: 1.0
				)
				.overlay(
					LinearGradient(
						gradient: Gradient(colors: [Color.black, Color.clear, Color.clear, Color.clear]),
						startPoint: .bottom,
						endPoint: .top
					)
					.rotation3DEffect(
						.degrees(20),
						axis: (x: 0.4, y: 0, z: 0),
						anchor: .center,
						perspective: 1.0
					)
				)

		}
	}
}
