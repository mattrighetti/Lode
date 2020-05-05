//
//  ColorPickerView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var colorIndex: GridIndex

    @State private var pickerSelection: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()

                ZStack {
                    Color.gradientsPalette[colorIndex.row][colorIndex.column]
                        .clipShape(Circle())
                        .frame(width: 150, height: 150, alignment: .center)
                }

                Spacer()
                Divider().padding(0)
                
                Picker(selection: $pickerSelection, label: Text("Picker")) {
                    Text("Color").tag(0)
                }
                .foregroundColor(Color.blue)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 50)

                Divider().padding(0)

                GridStack(rows: 3, columns: 5) { row, column in
                    CircleColorPickerElement(
                        row: row,
                        col: column,
                        currentIndex: self.$colorIndex
                    ).onTapGesture {
                        self.colorIndex = GridIndex(row: row, column: column)
                    }
                }.padding(.vertical)
            }
        }.background(Color("background").edgesIgnoringSafeArea(.all))
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    @State private static var colorIndex: GridIndex = GridIndex(row: 0, column: 0)
    static var previews: some View {
        ColorPickerView(colorIndex: $colorIndex).colorScheme(.dark)
    }
}
