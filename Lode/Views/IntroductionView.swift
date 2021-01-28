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
                Text("ParkMate")
            }

            Feature(iconName: "car.fill", iconColor: .yellow,
                    headline: "Keep track of everything",
                    description: "Keep track of everything")
                    .padding(.vertical)

            Feature(iconName: "person.2.fill", iconColor: .blue,
                    headline: "All in a single place",
                    description: "Save your marks, assignments and exams all in this app")
                    .padding(.vertical)

            Feature(iconName: "server.rack", iconColor: .green,
                    headline: "Extremely simple to use",
                    description: "Designed with ease of use in mind to get you back to work as soon as possible")
                    .padding(.vertical)
        }

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
                Text(headline)
                        .font(.subheadline)
                        .fontWeight(.bold)

                Text(description)
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
    }
}
