//
//  CardStack.swift
//  UniRadar
//
//  Created by Mattia Righetti on 25/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CardStack: View {
    @ObservedObject var deck: Deck = Deck()
    
    @State var draggingOffset: CGFloat = 0
    @State var isDragging: Bool = false
    @State var firstCardScale: CGFloat = Self.cardScaleWhenDraggingDown
    @State var isPresented: Bool = false
    @State var shouldDelay: Bool = true
    
    private static let cardTransitionDelay: Double = 0.2
    private static let cardOffset: CGFloat = 20
    private static let cardOpacity: Double = 0.4
    private static let cardShrinkRatio: CGFloat = 0.05
    private static let cardScaleWhenDraggingDown: CGFloat = 1.1
    private static let padding: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isPresented {
                    ForEach(deck.cards) { card in
                        DataCard(headerTitle: card.title, description: card.description, content: {
                            card.content()
                                .padding()
                        })
                        .opacity(self.opacity(for: card))
                        .offset(x: self.xOffset(for: card), y: self.yOffset(for: card))
                        .scaleEffect(self.scaleEffect(for: card))
                        .onTapGesture { }
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    self.dragGestureDidChange(value: value, card: card, geometry: geometry)
                                })
                                .onEnded({ value in
                                    self.dragGestureDidEnd(value: value, card: card, geometry: geometry)
                                })
                        )
                        .transition(.moveLeftFadingIn)
                        .animation(Animation.easeInOut.delay(self.transitionDelay(for: card)))
                    }
                }
            }
            .onAppear {
                if !isPresented {
                    self.isPresented.toggle()
                }
            }
        }
    }
}

// MARK: - Dragging interactions

extension CardStack {
    
    func dragGestureDidChange(value: DragGesture.Value, card: InfoCard, geometry: GeometryProxy) {
        guard deck.isFirst(card: card) else { return }
        draggingOffset = value.translation.width * 3.0
        isDragging = true
        firstCardScale = newFirstCardScale(geometry: geometry)
    }
    
    func dragGestureDidEnd(value: DragGesture.Value, card: InfoCard, geometry: GeometryProxy) {
        guard deck.isFirst(card: card) else { return }
        draggingOffset = 0
        deck.cards = cardsSortedAfterTranslation(draggedCard: card, xTranslation: value.translation.width, geometry: geometry)
        isDragging = false
    }
    
}

// MARK: - Layout functions

extension CardStack {
    
    private func cardsSortedAfterTranslation(draggedCard card: InfoCard, xTranslation: CGFloat, geometry: GeometryProxy) -> [InfoCard] {
        if abs(xTranslation) > 120 {
            draggingOffset = 0
            let newCards = [card] + Array(deck.cards.dropLast())
            return newCards
        }
        
        return deck.cards
    }
    
    private func newFirstCardScale(geometry: GeometryProxy) -> CGFloat {
        let newScale = 1 + draggingOffset / (1.5 * geometry.size.width)
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
    
    private func xOffset(for card: InfoCard) -> CGFloat {
        guard !deck.isFirst(card: card) else {
            return draggingOffset
        }
        
        return 0.0
    }
    
    private func yOffset(for card: InfoCard) -> CGFloat {
        guard !deck.isFirst(card: card) else {
            return 0
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
        AnyTransition.move(edge: .leading).combined(with: .opacity)
    }
}

struct CardStack_Previews: PreviewProvider {
    static var previews: some View {
        CardStack().colorScheme(.dark)
    }
}
