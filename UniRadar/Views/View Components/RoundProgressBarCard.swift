//
//  CfuCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct RoundProgressBarCard: View {
    
    var title: String
    var cfu: Int
    var totalCfu: Int
    var width: CGFloat
    var height: CGFloat

    var body: some View {

        VStack(alignment: .leading) {

            Text("\(title)")
                .font(.custom("Avenir Next Bold", size: 30.0))
                .foregroundColor(.flatBlack)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 0))

            ZStack(alignment: .center) {

                Circle()
                    .stroke(Color.flatGray.opacity(0.1), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: self.width, height: self.height)

                Circle()
                    .trim(from: 1 - (CGFloat(self.cfu) / CGFloat(self.totalCfu)), to: 1)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [.black, .flatDarkRed]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: self.width, height: self.height)
                    .padding()

                VStack {

                    Text("\(cfuPercentage())%")
                        .font(.custom("Avenir Next Bold", size: 25.0))
                        .foregroundColor(.flatBlack)
                        .padding(.horizontal, 30)

                    Text("\(self.cfu)/\(self.totalCfu)")
                        .font(.custom("Avenir Next Regular", size: 10.0))
                        .foregroundColor(.flatBlack)
                        .padding(.horizontal, 30)
                }

            }

        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 2)
        )

    }
    
    func cfuPercentage() -> Int {
        return Int((Double(self.cfu) / Double(self.totalCfu) * 100).rounded())
    }

}

struct RoundProgressBarCard_Previews: PreviewProvider {
    
    static var cfu = 100
    static var totalCfu = 150
    
    static var previews: some View {
        RoundProgressBarCard(title: "Test", cfu: cfu, totalCfu: totalCfu, width: 200, height: 200)
    }
}
