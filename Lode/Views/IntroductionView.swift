//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

struct IntroductionView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("showIntro") private var showIntro: Bool = true

    var body: some View {
        VStack(alignment: .center) {
            MainTitle {
                Text("Welcome To")
                Text("Lode")
            }

            Feature(iconName: "doc.fill", iconColor: .yellow,
                    headline: "Keep track of your courses",
                    description: "Save your marks and make expectations")
                        .padding(.vertical)

            Feature(iconName: "apps.iphone", iconColor: .blue,
                    headline: "All you need in a single app",
                    description: "Save your marks, assignments and exams all in a single application")
                        .padding(.vertical)

            Feature(iconName: "wand.and.stars", iconColor: .green,
                    headline: "Extremely simple to use",
                    description: "Designed with ease of use in mind with great care to user experience and design")
                        .padding(.vertical)
            
            Feature(iconName: "globe", iconColor: .orange,
                    headline: "Open source",
                    description: "Contribute to the application and help us improve it")
                        .padding(.vertical)
        }
        .padding(.top)

        Spacer()

        Button(action: {
            self.showIntro.toggle()
            presentationMode.wrappedValue.dismiss()
        }, label: {
            RectangularButtonLabel {
                Text("Continue")
            }
        })
        .padding(.horizontal)

        Spacer()
    }
}

struct MainTitle<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .font(.system(size: 40.0, weight: .bold))
        .padding(.top, 40)
        .padding(.bottom, 40)
    }
}

struct RectangularButtonLabel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack {
            Spacer()
            content
                    .padding()
            Spacer()
        }
        .background(Color.blue)
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }
}

private struct Feature: View {
    var iconName: String
    var iconColor: Color
    var headline: String
    var description: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(iconColor)
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(headline))
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(LocalizedStringKey(description))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            Spacer()
        }
        .padding(.horizontal, 25)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
            .environment(\.locale, .init(identifier: "it"))
    }
}
