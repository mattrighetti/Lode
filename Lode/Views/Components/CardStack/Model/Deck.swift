//
//  Deck.swift
//  UniRadar
//
//  Created by Mattia Righetti on 25/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Foundation
import SwiftUI

class Deck: ObservableObject {
    @Published var cards: [InfoCard] = [
        InfoCard(title: NSLocalizedString("Your CFU", comment: ""), description: "", content: {
            AnyView( CfuCard() )
        }),
        InfoCard(title: NSLocalizedString("Your Average", comment: ""), description: "", content: {
            AnyView( AverageCard() )
        }),
        InfoCard(title: NSLocalizedString("Exams Countdown", comment: ""), description: "", content: {
            AnyView( MainInfoCard() )
        })
    ].reversed()
    
    func index(of card: InfoCard) -> Int { cards.count - cards.firstIndex(of: card)! - 1 }
    
    func isFirst(card: InfoCard) -> Bool { index(of: card) == 0 }
    
}

struct InfoCard: Identifiable, Equatable {
    var id: String { title }
    var title: String
    var description: String
    var content: () -> AnyView

    static func == (lhs: InfoCard, rhs: InfoCard) -> Bool {
        lhs.id == rhs.id
    }
}
