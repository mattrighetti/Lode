//
//  HorizontalCards.swift
//  UniRadar
//
//  Created by Mattia Righetti on 23/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HorizontalCards: View {
    
    var body: some View {
        HStack {
            // TODO fix this
//            DataCard(headerTitle: cards[0].title, description: "", content: {
//                VStack {
//                    Spacer()
//                    cards[0].content()
//                        .padding()
//                    Spacer()
//                }
//            }).padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 7.5))
//
//            DataCard(headerTitle: cards[1].title, description: "", content: {
//                VStack {
//                    Spacer()
//                    cards[1].content().padding()
//                    Spacer()
//                }
//            }).padding(EdgeInsets(top: 15, leading: 7.5, bottom: 15, trailing: 7.5))
        }
    }
}

struct HorizontalCards_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCards().previewDevice("iPad (7th generation)")
    }
}