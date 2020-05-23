//
//  HorizontalCards.swift
//  UniRadar
//
//  Created by Mattia Righetti on 23/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HorizontalCards: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            DataCard(headerTitle: cards[0].title, description: "", content: {
                VStack {
                    Spacer()
                    cards[0].content(self.viewModel)
                        .padding()
                    Spacer()
                }
            }).padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 7.5))
            
            DataCard(headerTitle: cards[1].title, description: "", content: {
                VStack {
                    Spacer()
                    cards[1].content(self.viewModel).padding()
                    Spacer()
                }
            }).padding(EdgeInsets(top: 15, leading: 7.5, bottom: 15, trailing: 7.5))
            
            DataCard(headerTitle: cards[2].title, description: "", content: {
                VStack {
                    Spacer()
                    cards[2].content(self.viewModel)
                        .padding()
                    Spacer()
                }
            }).padding(EdgeInsets(top: 15, leading: 7.5, bottom: 15, trailing: 15))
        }
    }
}

struct HorizontalCards_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        HorizontalCards(viewModel: ViewModel(context: context!)).previewDevice("iPad (7th generation)")
    }
}
