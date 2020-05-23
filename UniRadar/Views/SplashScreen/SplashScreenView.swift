//
//  SplashScreen.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct SplashscreenFeature {
    let lottieName: String
    let featureTitle: String
    let featureDescription: String

    init(withLottie lottieName: String, title featureTitle: String, description: String) {
        self.featureDescription = description
        self.featureTitle = featureTitle
        self.lottieName = lottieName
    }
}

struct SplashScreenView: View {
    
    @Environment(\.presentationMode) var presentatitonMode

    var features: [SplashscreenFeature] = [
        SplashscreenFeature(
            withLottie: "manwriting",
            title: NSLocalizedString("Keep track of everything", comment: ""),
            description: NSLocalizedString("Keep track of everything", comment: "")
        ),
        SplashscreenFeature(
            withLottie: "swipeup",
            title: NSLocalizedString("All in a single place", comment: ""),
            description: NSLocalizedString("Save your marks, assignments and exams all in this app", comment: "")
        ),
        SplashscreenFeature(
            withLottie: "resting",
            title: NSLocalizedString("Extremely simple to use", comment: ""),
            description: NSLocalizedString("Designed with ease of use in mind to get you back to work as soon as possible", comment: "")
        )
    ]

    @State var featureIndex: Int = 0
    @State var horizontalDrag: CGFloat = 0.0

    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "chevron.compact.down")
                    .font(.title)
                    .foregroundColor(.flatAirForceBlue)
                    .padding()

                Spacer()

                VStack {
                    SplashScreenFeatureView(splashscreenFeature: features[featureIndex])
                        .padding(.horizontal, 20)
                }

                Spacer()
                Spacer()
                
                Button(action: {
                    self.presentatitonMode.wrappedValue.dismiss()
                }, label: {
                    Text("Start").padding(.horizontal, 50).card()
                })
                .background(Color("cardBackground"))
                .cornerRadius(8)

                HStack {
                    Circle()
                        .foregroundColor(featureIndex == 0 ? Color("circleSelected") : Color("circle"))
                        .frame(width: 7, height: 7, alignment: .center)

                    Circle()
                        .foregroundColor(featureIndex == 1 ? Color("circleSelected") : Color("circle"))
                        .frame(width: 7, height: 7, alignment: .center)

                    Circle()
                        .foregroundColor(featureIndex == 2 ? Color("circleSelected") : Color("circle"))
                        .frame(width: 7, height: 7, alignment: .center)
                }.padding()
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
}

struct SplashScreenFeatureView: View {

    var splashscreenFeature: SplashscreenFeature
    
    var lottieSize: CGFloat {
        (UIScreen.main.bounds.width / 2)
    }
    
    var body: some View {
        VStack {
            LottieView(lottieAnimationName: self.splashscreenFeature.lottieName)
                .frame(width: self.lottieSize, height: self.lottieSize, alignment: .center)

            Text(splashscreenFeature.featureTitle)
                .fontWeight(.heavy)
                .padding([.top, .bottom])
                .transition(.offset())
                .animation(.interactiveSpring())

            Text(splashscreenFeature.featureDescription)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .transition(.offset())
                .animation(.interactiveSpring())
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashScreenView()
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .dark)
            
            SplashScreenView()
                .previewDevice("iPad Pro (12.9-inch)")
                .environment(\.colorScheme, .dark)
        }
    }
}
