//
//  ListView.swift
//  Lode
//
//  Created by Mattia Righetti on 02/03/21.
//

import SwiftUI

struct ListView<Content: View>: View {
    let content: Content
    let header: Text?
    let footer: Text?
    
    init(header: Text? = nil, footer: Text? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = header
        self.footer = footer
    }
    
    var body: some View {
        Section(header: header, footer: footer) {
            content
        }
        .listRowBackground(Color.background)
        .listRowInsets(.some(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)))
    }
}
