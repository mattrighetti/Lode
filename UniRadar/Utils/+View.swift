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
        
        var navigationBarWidth: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return (UIScreen.main.bounds.size.width - 32)
            } else {
                return (UIScreen.main.bounds.size.width / 2.8)
            }
        }
        
        var leadingWidth: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 70
            } else {
                return (navigationBarWidth * 1/6)
            }
        }
        
        var centerWidth: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 200
            } else {
                return (navigationBarWidth * 4/6)
            }
        }
        
        var trailingWidth: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 50
            } else {
                return (navigationBarWidth * 1/6)
            }
        }
        
        return self.navigationBarItems(
            leading:
                HStack {
                    HStack {
                        leading
                    }
                    .frame(width: leadingWidth, alignment: .leading)
                    Spacer()
                    HStack {
                        center
                    }
                    .frame(width: centerWidth, alignment: .center)
                    Spacer()
                    HStack {
                        trailing
                    }
                    .frame(width: trailingWidth, alignment: .trailing)
                }
                .frame(width: navigationBarWidth)

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
