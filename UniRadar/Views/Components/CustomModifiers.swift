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
