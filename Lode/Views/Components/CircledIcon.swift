//
//  CircledIcon.swift
//  Lode
//
//  Created by Mattia Righetti on 01/03/21.
//

import SwiftUI

struct CircledIcon<Content: View>: View {
    let color: Color
    var content: Content
    
    public init(color: Color, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        Circle()
            .fill(color)
            .overlay(content.foregroundColor(.white))
            .frame(width: 30, height: 30)
    }
}

struct CircledIcon_Previews: PreviewProvider {
    static var previews: some View {
        CircledIcon(color: .red) {
            Image(systemName: "person")
                .foregroundColor(.white)
        }
    }
}
