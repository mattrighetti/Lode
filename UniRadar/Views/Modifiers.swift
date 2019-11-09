//
//  Modifiers.swift
//  UniRadar
//
//  Created by Mattia Righetti on 09/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct BorderedCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1))
            .shadow(color: Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.3), radius: 5, x: 0, y: 0)
    }
}

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.3), radius: 5, x: 0, y: 0)
    }
}

struct RoundedGrayTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.05))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
}
