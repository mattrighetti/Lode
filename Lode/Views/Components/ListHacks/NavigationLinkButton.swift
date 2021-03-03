//
//  NavigationLinkButton.swift
//  Lode
//
//  Created by Mattia Righetti on 02/03/21.
//

import SwiftUI

struct NavigationLinkButton<Destination: View, Content: View>: View {
    @Binding var isActive: Bool
    let content: Content
    let destination: Destination
    
    init(destination: Destination, isActive: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.destination = destination
        self._isActive = isActive
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Button(action: {
                isActive.toggle()
            }, label: {
                content
            }).buttonStyle(PlainButtonStyle())
            NavigationLink(
                destination: destination,
                isActive: $isActive,
                label: {
                    EmptyView()
                }
            )
            .hidden()
            .disabled(true)
        }
    }
}
