//
//  +View.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

extension View {
    func navigationBarItems<L, C, T>(leading: L, center: C, trailing: T) -> some View
    where L: View, C: View, T: View {
        self.navigationBarItems(
            leading:
                HStack {
                    HStack {
                        leading
                    }
                    .frame(width: 70, alignment: .leading)
                    Spacer()
                    HStack {
                        center
                    }
                    .frame(width: 200, alignment: .center)
                    Spacer()
                    HStack {
                        //Text("asdasd")
                        trailing
                    }
                    //.background(Color.blue)
                    .frame(width: 50, alignment: .trailing)
                }
                //.background(Color.yellow)
                .frame(width: UIScreen.main.bounds.size.width - 32)

        )

    }
}

// MARK: - Modifier

extension View {
    
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
    
    func card() -> some View {
        ModifiedContent(content: self, modifier: CardStyle())
    }
    
    func sectionTitle() -> some View {
        ModifiedContent(content: self, modifier: SectionTitle())
    }
    
    func badgePillWithImage(color: Color) -> some View {
        ModifiedContent(content: self, modifier: BadgePillWithImageStyle(color: color))
    }
    
    func badgePill(color: Color) -> some View {
        ModifiedContent(content: self, modifier: BadgePillStyle(color: color))
    }
    
    func borderBox(color: Color) -> some View {
        ModifiedContent(content: self, modifier: BorderBox(color: color))
    }
    
    func segmentedButton() -> some View {
        ModifiedContent(content: self, modifier: SegmentedButton())
    }
    
    func singleSeparator() -> some View {
        ModifiedContent(content: self, modifier: ListSingleSeparatorStyle())
    }
    
    func scrollViewWithBackground() -> some View {
        ModifiedContent(content: self, modifier: ScrollViewBackgroundModifier())
    }
    
    func scrollViewWithoutBackground() -> some View {
        ModifiedContent(content: self, modifier: ScrollViewNoBackgroundModifier())
    }
    
}
