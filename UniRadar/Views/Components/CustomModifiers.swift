//
//  CustomModifiers.swift
//  UniRadar
//
//  Created by Mattia Righetti on 12/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct SegmentedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: [7]
                    )
                )
                .foregroundColor(Color("bw"))
        )
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color("cardBackground"))
            .cornerRadius(8)
    }
}

struct BorderBox: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke()
                    .foregroundColor(color)
            )
    }
}

struct BadgePillStyle: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 13.0, weight: .regular, design: .rounded))
            .padding(7)
            .background(color)
            .cornerRadius(8)
            .padding(.bottom, 5)
    }
}

struct BadgePillWithImageStyle: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(7)
            .font(.system(size: 13.0, weight: .regular, design: .rounded))
            .background(color)
            .cornerRadius(8)
    }
}

struct SectionTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("bw"))
            .font(.system(size: 17, weight: .semibold, design: .default))
    }
}
