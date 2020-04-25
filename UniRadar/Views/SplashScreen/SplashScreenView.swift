//
//  SplashScreen.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct SplashscreenFeature {
    let imageFeature: String
    let featureTitle: String
    let featureDescription: String

    init(withImage imageLiteral: String, title featureTitle: String, description: String) {
        self.featureDescription = description
        self.featureTitle = featureTitle
        self.imageFeature = imageLiteral
    }
}

struct SplashScreenView: View {

    var features: [SplashscreenFeature] = [
        SplashscreenFeature(
            withImage: "features", title: "Keep track of everything",
            description: "Keep track of everything"),
        SplashscreenFeature(
            withImage: "work-group", title: "All in a single place",
            description: "Save your marks, reminders and exams all in this app"),
        SplashscreenFeature(
            withImage: "work-time", title: "Extremely simple to use",
            description: "Designed with ease of use in mind to get you back to work as soon as possible")
    ]

    @State var featureIndex: Int = 1
    @State var horizontalDrag: CGFloat = 0.0

    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .font(.title)
                .foregroundColor(.flatLightGray)
                .padding()

            Spacer()

            VStack {
                SplashScreenFeatureView(splashscreenFeature: features[featureIndex])
                    .padding(.horizontal, 20)
            }

            Spacer()
            Spacer()

            HStack {
                Circle()
                    .foregroundColor(featureIndex == 0 ? .flatDarkGray : .flatLightGray)
                    .frame(width: 10, height: 10, alignment: .center)

                Circle()
                    .foregroundColor(featureIndex == 1 ? .flatDarkGray : .flatLightGray)
                    .frame(width: 10, height: 10, alignment: .center)

                Circle()
                    .foregroundColor(featureIndex == 2 ? .flatDarkGray : .flatLightGray)
                    .frame(width: 10, height: 10, alignment: .center)
            }
        }.gesture(
            DragGesture()
                .onEnded { action in
                    if action.translation.width > 50.0 && self.featureIndex > 0 {
                        self.featureIndex -= 1
                    } else if action.translation.width < -50.0 && self.featureIndex < 2 {
                        self.featureIndex += 1
                    }
                }
        )
    }
}

struct SplashScreenFeatureView: View {

    var splashscreenFeature: SplashscreenFeature

    var body: some View {
        VStack {
            Image(.init(stringLiteral: splashscreenFeature.imageFeature))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)

            Text(splashscreenFeature.featureTitle)
                .fontWeight(.heavy)
                .padding([.top, .bottom])

            Text(splashscreenFeature.featureDescription)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashScreenView()
                .previewDevice("iPhone 11")
                .environment(\.colorScheme, .light)
        }
    }
}
