//
//  CardStack.swift
//  UniRadar
//
//  Created by Mattia Righetti on 25/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CardStack: View {
    
    private static let cardTransitionDelay: Double = 0.1
    private static let cardOffset: CGFloat = 20
    private static let cardOpacity: Double = 0.05
    private static let cardShrinkRatio: CGFloat = 0.05
    private static let cardScaleWhenDraggingDown: CGFloat = 1.1
    private static let padding: CGFloat = 20
    
    @ObservedObject var deck: Deck = Deck(cards: [
        InfoCard(text: "1", color: .yellow),
        InfoCard(text: "2", color: .red),
        InfoCard(text: "3", color: .black),
        InfoCard(text: "4", color: .darkRed),
        InfoCard(text: "5", color: .blue)
    ])
    @State var draggingOffset: CGFloat = 0
    @State var isDragging: Bool = false
    @State var firstCardScale: CGFloat = Self.cardScaleWhenDraggingDown
    @State var isPresented: Bool = false
    @State var shouldDelay: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if self.isPresented {
                    ForEach(self.deck.cards) { InfoCard in
                        InfoCard
                            .opacity(self.opacity(for: InfoCard))
                            .offset(x: 0, y: self.offset(for: InfoCard))
                            .scaleEffect(self.scaleEffect(for: InfoCard))
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        self.dragGestureDidChange(value: value, card: InfoCard, geometry: geometry)
                                    })
                                    .onEnded({ value in
                                        self.dragGestureDidEnd(value: value, card: InfoCard, geometry: geometry)
                                    })
                            )
                            .transition(.moveLeftFadingIn)
                            .animation(Animation.easeInOut.delay(self.transitionDelay(for: InfoCard)))
                    }
                }
            }.padding(.horizontal, 50)
             .padding(.vertical, 30)
            .onAppear {
                self.isPresented.toggle()
            }
        }
    }
}

// MARK: - Dragging interactions

extension CardStack {
    
    func dragGestureDidChange(value: DragGesture.Value, card: InfoCard, geometry: GeometryProxy) {
        guard deck.isFirst(card: card) else { return }
        draggingOffset = value.translation.height
        isDragging = true
        firstCardScale = newFirstCardScale(geometry: geometry)
    }
    
    func dragGestureDidEnd(value: DragGesture.Value, card: InfoCard, geometry: GeometryProxy) {
        guard deck.isFirst(card: card) else { return }
        draggingOffset = 0
        deck.cards = cardsSortedAfterTranslation(draggedCard: card, yTranslation: value.translation.height, geometry: geometry)
        isDragging = false
    }
    
}

// MARK: - Layout functions

extension CardStack {
    
    private func cardsSortedAfterTranslation(draggedCard card: InfoCard, yTranslation: CGFloat, geometry: GeometryProxy) -> [InfoCard] {
        let cardHeight = (geometry.size.width / CGFloat(16 / 9) - Self.padding)
        if abs(yTranslation + CGFloat(deck.cards.count) * -Self.cardOffset) > cardHeight {
            let newCards = [card] + Array(deck.cards.dropLast())
            return newCards
        }
        
        return deck.cards
    }
    
    private func newFirstCardScale(geometry: GeometryProxy) -> CGFloat {
        let newScale = 1 + draggingOffset / (1.5 * geometry.size.height)
        if draggingOffset > 0 {
            return min(Self.cardScaleWhenDraggingDown, newScale)
        } else {
            return max(1 - CGFloat(deck.cards.count) * Self.cardShrinkRatio, newScale)
        }
    }
    
    private func transitionDelay(for card: InfoCard) -> Double {
        guard shouldDelay else { return 0 }
        return Double(deck.index(of: card)) * Self.cardTransitionDelay
    }
    
    private func opacity(for card: InfoCard) -> Double {
        let cardIndex = Double(deck.index(of: card))
        return 1 - cardIndex * Self.cardOpacity
    }
    
    private func offset(for card: InfoCard) -> CGFloat {
        guard !deck.isFirst(card: card) else {
            return draggingOffset
        }
        let cardIndex = CGFloat(deck.index(of: card))
        return cardIndex * Self.cardOffset
    }
    
    private func scaleEffect(for card: InfoCard) -> CGFloat {
        guard !(isDragging && deck.isFirst(card: card)) else { return firstCardScale }
        let cardIndex = CGFloat(deck.index(of: card))
        return 1 - cardIndex * Self.cardShrinkRatio
    }
    
}

extension AnyTransition {
    static var moveLeftFadingIn: AnyTransition {
        return AnyTransition.move(edge: .leading).combined(with: .opacity)
    }
}

struct CardStack_Previews: PreviewProvider {
    static var previews: some View {
        CardStack()
    }
}
