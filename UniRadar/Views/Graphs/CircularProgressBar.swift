//
//  CircularProgressBar.swift
//  UniRadar
//
//  Created by Mattia Righetti on 16/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CircularProgressBar: View {
    @Binding var progress: CGFloat
    
    var colors: [Color] = [Color.lightRed, Color.darkRed]

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("background"), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(350)
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
            ).rotationEffect(.degrees(-90))
        }.padding()
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    @State public static var progress: CGFloat = 1
    static var previews: some View {
        CircularProgressBar(progress: $progress)
    }
}
