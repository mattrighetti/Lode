//
//  ColorPickerView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ColorPickerView: View {

    @State private var pickerSelection: Int = 0
    @Binding var selectedColor: Color

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()

                ZStack {
                    selectedColor
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

                LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                    ForEach(Color.gradientsPalette, id: \.self) { color in
                        CircleColorPickerElement(color: color, isSelected: color == selectedColor).onTapGesture {
                            selectedColor = color
                        }
                    }
                }.frame(width: .infinity, height: 230, alignment: .center)
            }
        }.background(Color("background").edgesIgnoringSafeArea(.all))
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.red))
            .colorScheme(.dark)
    }
}
