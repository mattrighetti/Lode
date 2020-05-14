//
//  BarShape.swift
//  UniRadar
//
//  Created by Mattia Righetti on 18/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct BarChartView: View {

    var arrayValues: [Double]
    var color: Color
    var maxValue: Double = 30.0 - 17.0
    var adjustedValues: [Double] {
        var array = [Double]()
        
        arrayValues.forEach { value in
            array.append(value - 17)
        }
        
        let remaining = 40 - arrayValues.count
        
        for _ in 0...remaining {
            array.append(0.0)
        }
        
        return array
    }
    
    var indexes = [0, 4, 8, 12]
    var stringSingal = ["30", "26", "22", "18"]

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ForEach(self.indexes.indices, id: \.self) { index in
                    VStack {
                        HStack(spacing: 5.5) {
                            Text(self.stringSingal[index])
                                .font(.system(size: 10))
                                .opacity(0.7)
                            
                            ForEach(1..<((Int(geometry.size.width) / 7)) ) { _ in
                                Circle()
                                    .fill(Color("bw"))
                                    .opacity(0.2)
                                    .frame(width: 1, height: 1)
                            }
                            
                            Spacer()
                        }
                        .padding(.top, (((geometry.size.height - 25) / 12) * CGFloat(self.indexes[index])))
                    }
                }
                
                HStack(alignment: .bottom, spacing: 1) {
                    ForEach(self.adjustedValues, id: \.self) { value in
                        Capsule()
                            .fill(self.color)
                            .frame(
                                height:
                                CGFloat(value / self.maxValue) * geometry.size.height >= 0.1 ?
                                (CGFloat(value / self.maxValue) * geometry.size.height) - 7
                                : 7.0
                            )
                    }
                }
                .padding(.horizontal, 20)
                
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BarChartView(
                arrayValues: [
                    30.0, 29.0, 28.0, 27.0, 26.0, 25.0, 24.0, 23.0, 22.0, 21.0, 20.0, 19.0, 18.0
                ],
                color: .flatRed
            )
        }
        .frame(height: 250)
        .previewDevice("iPhone 11")
    }
}
