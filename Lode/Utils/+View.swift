//
//  +View.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

// MARK: - Modifier

extension View {

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
