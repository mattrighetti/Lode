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
    
    @Published var cards: [InfoCard]
    
    init(cards: [InfoCard]) {
        self.cards = cards.reversed()
    }
    
    func index(of card: InfoCard) -> Int {
        return cards.count - cards.firstIndex(of: card)! - 1
    }
    
    func isFirst(card: InfoCard) -> Bool {
        return index(of: card) == 0
    }
    
}

struct InfoCard: Identifiable, Equatable {
    
    var id: String {
        return title
    }
    
    var title: String
    var description: String
    var progress: CGFloat
}
