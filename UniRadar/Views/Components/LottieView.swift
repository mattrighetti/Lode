//
//  LottieView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 22/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView

    var lottieAnimationName: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = AnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if let animationView = uiView.subviews.first! as? AnimationView {
            animationView.animation = Animation.named(lottieAnimationName)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
        }
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(lottieAnimationName: "swipeup")
    }
}
