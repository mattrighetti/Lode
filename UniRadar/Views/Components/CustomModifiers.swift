//
//  CustomModifiers.swift
//  UniRadar
//
//  Created by Mattia Righetti on 12/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

struct SegmentedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 1,
                            dash: [7]
                        )
                    )
                    .foregroundColor(Color("bw"))
            )
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color("cardBackground"))
            .cornerRadius(8)
    }
}

struct BorderBox: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke()
                    .foregroundColor(color)
            )
    }
}

struct BadgePillStyle: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 13.0, weight: .regular, design: .rounded))
            .padding(7)
            .background(color)
            .cornerRadius(8)
            .padding(.bottom, 5)
    }
}

struct BadgePillWithImageStyle: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(7)
            .font(.system(size: 13.0, weight: .regular, design: .rounded))
            .background(color)
            .cornerRadius(8)
    }
}

struct SectionTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("bw"))
            .font(.system(size: 17, weight: .semibold, design: .default))
    }
}

struct ListSingleSeparatorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear { UITableView.appearance().separatorStyle = .singleLine }
            .onDisappear { UITableView.appearance().separatorStyle = .none }
    }
}

struct ScrollViewBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear { UIScrollView.appearance().backgroundColor = UIColor(named: "background") }
            .onDisappear { UIScrollView.appearance().backgroundColor = .none }
    }
}

struct ScrollViewNoBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear { UIScrollView.appearance().backgroundColor = .none }
            .onDisappear { UIScrollView.appearance().backgroundColor = UIColor(named: "background") }
    }
}

// MARK: - KeyboardAdaptive (not working)

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        // 1.
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    print("Trigger onReceive")
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight - 100
                    print("keyboardTop:", keyboardTop)
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    print("focusedTextInputBottom:", focusedTextInputBottom)
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    print(self.bottomPadding)
                }
                .animation(.easeOut(duration: 0.16))
        }
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
