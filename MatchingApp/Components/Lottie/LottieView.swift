//
//  LottieView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/06.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    private let lottieView = LottieAnimationView()
    private let baseView = UIView()
    let isActive: Bool
    init(animationResourceName: String, loopMode: LottieLoopMode, isActive: Bool) {
        self.isActive = isActive
        lottieView.animation = LottieAnimation.named(animationResourceName)
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = loopMode
        baseView.addSubview(lottieView)
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: lottieView.topAnchor),
            baseView.leadingAnchor.constraint(equalTo: lottieView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: lottieView.trailingAnchor),
            baseView.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor)
        ])
        lottieView.updateConstraints()
        lottieView.play()
    }
    
    func makeUIView(context: Context) -> UIView {
        baseView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

