//
//  GradientPickerView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 25/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct IconColorPickerView: View {
    
    @Binding var selectedColor: Color
    @Binding var selectedGlyph: String

    @State private var pickerSelection: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()

                ZStack {
                    selectedColor
                        .clipShape(Circle())
                        .frame(width: 150, height: 150, alignment: .center)

                    Image(systemName: selectedGlyph)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }

                Spacer()
                Divider().padding(0)
                
                Picker(selection: $pickerSelection, label: Text("Picker")) {
                    Text("Color").tag(0)
                    Text("Glyph").tag(1)
                }
                .foregroundColor(Color.blue)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 50)

                Divider().padding(0)
                
                LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center, spacing: 15) {
                    gridPickerContent()
                }.frame(height: 200, alignment: .center)
            }
        }
        .background(Color("background").edgesIgnoringSafeArea(.all))
    }
    
    @ViewBuilder
    private func gridPickerContent() -> some View {
        if pickerSelection == 0 {
            ForEach(Color.gradientsPalette, id: \.self) { color in
                CircleColorPickerElement(color: color, isSelected: color == selectedColor).onTapGesture {
                    self.selectedColor = color
                }
            }
        } else {
            ForEach(Glyph.glyphArray, id: \.self) { glyph in
                GlyphColorPickerElement(glyph: glyph, isSelected: glyph == selectedGlyph).onTapGesture {
                    self.selectedGlyph = glyph
                }
            }
        }
    }
}

struct CircleColorPickerElement: View {
    var color: Color
    var isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
            generateSelection()
        }
    }

    @ViewBuilder
    func generateSelection() -> some View {
        if isSelected {
            Circle()
                .stroke()
                .fill(Color.white)
                .frame(width: 45, height: 45)
        } else {
            EmptyView()
        }
    }
}

struct GlyphColorPickerElement: View {
    var glyph: String
    var isSelected: Bool

    var body: some View {
        ZStack {
            Image(systemName: glyph)
                .frame(width: 50, height: 50)
            generateSelection()
        }
    }

    @ViewBuilder
    func generateSelection() -> some View {
        if isSelected {
            Circle()
                .stroke()
                .frame(width: 45, height: 45)
        } else {
            EmptyView()
        }
    }
}

struct GradientPickerView_Previews: PreviewProvider {
    @State private static var iconName: String = "pencil"

    static var previews: some View {
        IconColorPickerView(selectedColor: .constant(.red), selectedGlyph: .constant("car"))
            .environment(\.locale, .init(identifier: "it"))
            .colorScheme(.dark)
    }
}
