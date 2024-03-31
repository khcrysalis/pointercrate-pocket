//
//  OnboardingBackdrop.swift
//  pointercrate
//
//  Created by samara on 3/30/24.
//

import Foundation
import SwiftUI
import AVKit

extension OnboardingViewController {
	func videoPlayerWithEffects(player: AVPlayer) -> some View {
		return ZStack {
			VideoPlayer(player: player)
				.edgesIgnoringSafeArea(.all)
				.onAppear { player.play() }
				.onTapGesture {}
			
			VisualEffectView(blurStyle: .systemUltraThinMaterialDark)
				.edgesIgnoringSafeArea(.all)
			
			LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .black]), startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
		}
	}
}

extension AVPlayerViewController {
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.showsPlaybackControls = false
		self.videoGravity = .resizeAspectFill
	}
}

struct VisualEffectView: UIViewRepresentable {
	var blurStyle: UIBlurEffect.Style = .systemMaterial
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
