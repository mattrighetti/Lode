//
//  CircularProgressBar.swift
//  UniRadar
//
//  Created by Mattia Righetti on 16/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CircularProgressBar: View {
    var currentValue: Int
    var maxValue: Int
    var color: Color

    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .center) {

                Circle()
                    .stroke(self.color.opacity(0.5), style: StrokeStyle(lineWidth: screen.size.width / 28, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: screen.size.width / 1.2, height: screen.size.height / 1.2)

                Circle()
                    .trim(from: 1 - (CGFloat(self.currentValue) / CGFloat(self.maxValue)), to: 1)
                    .stroke(self.color ,style: StrokeStyle(lineWidth: screen.size.width / 35, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: screen.size.width / 1.05, height: screen.size.height / 1.05)
                    .padding()

                VStack {

                    Text("\(self.computePercentage())%")
                        .font(.custom("Avenir Next Bold", size: screen.size.width / 5))
                        .foregroundColor(self.color)

                    Text("\(self.currentValue)/\(self.maxValue)")
                        .font(.custom("Avenir Next Regular", size: screen.size.width / 10))
                        .foregroundColor(self.color)
                }
            }
        }
    }
    
    // Maybe this method should update some @State props
    func computePercentage() -> Int {
        return Int( (Double(self.currentValue) / Double(self.maxValue) * 100).rounded() )
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(currentValue: 30, maxValue: 180, color: .flatLightRed)
    }
}
