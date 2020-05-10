//
//  CircularProgressBar.swift
//  UniRadar
//
//  Created by Mattia Righetti on 16/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CircularProgressBar: View {
    
    var progress: CGFloat
    var lineWidth: CGFloat = 20.0
    var color: Color = Color.darkRed

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("background"), lineWidth: self.lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round)
                ).rotationEffect(.degrees(-90))
        }.padding()
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var progress: CGFloat = 1
    static var previews: some View {
        CircularProgressBar(progress: progress)
    }
}
