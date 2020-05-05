//
//  GradientPickerView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 25/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct IconColorPickerView: View {

    @Binding var colorIndex: GridIndex
    @Binding var glyphIndex: GridIndex

    @State private var pickerSelection: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()

                ZStack {
                    Color.gradientsPalette[colorIndex.row][colorIndex.column]
                        .clipShape(Circle())
                        .frame(width: 150, height: 150, alignment: .center)

                    Image(systemName: Glyph.glyphArray[glyphIndex.row][glyphIndex.column])
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

                GridStack(rows: 3, columns: 5) { row, column in
                    Group {
                        if self.$pickerSelection.wrappedValue == 0 {
                            CircleColorPickerElement(
                                row: row,
                                col: column,
                                currentIndex: self.$colorIndex
                            ).onTapGesture {
                                self.colorIndex = GridIndex(row: row, column: column)
                            }
                        } else {
                            GlyphColorPickerElement(
                                row: row,
                                col: column,
                                currentIndex: self.$glyphIndex
                            ).onTapGesture {
                                self.glyphIndex = GridIndex(row: row, column: column)
                            }
                        }
                    }
                }.padding(.vertical)
            }
        }.background(Color("background").edgesIgnoringSafeArea(.all))
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }.padding(.horizontal, 5)
                }.padding(.vertical, 5)
            }
        }
    }
}

struct CircleColorPickerElement: View {

    var row: Int
    var col: Int

    @Binding var currentIndex: GridIndex

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gradientsPalette[row][col])
                .frame(width: 50, height: 50)
            generateSelection()
        }
    }

    func generateSelection() -> AnyView {
        if currentIndex.column == col && currentIndex.row == row {
            return AnyView(
                Circle()
                    .stroke()
                    .fill(Color.gradientsPalette[row][col])
                    .frame(width: 45, height: 45)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct GlyphColorPickerElement: View {

    var row: Int
    var col: Int

    @Binding var currentIndex: GridIndex

    var body: some View {
        ZStack {
            Image(systemName: Glyph.glyphArray[row][col])
            .frame(width: 50, height: 50)
            generateSelection()
        }
    }

    func generateSelection() -> AnyView {
        if currentIndex.column == col && currentIndex.row == row {
            return AnyView(
                Circle()
                    .stroke()
                    .fill(Color.gradientsPalette[row][col])
                    .frame(width: 45, height: 45)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct GradientPickerView_Previews: PreviewProvider {
    @State private static var iconName: String = "pencil"
    @State private static var index: GridIndex = GridIndex(row: 1, column: 1)

    static var previews: some View {
        IconColorPickerView(colorIndex: $index, glyphIndex: $index).colorScheme(.dark)
    }
}
