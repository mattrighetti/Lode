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
    var maxValue: Double {
        arrayValues.max() ?? -1
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 1) {
                ForEach(self.arrayValues, id: \.self) { value in
                    Capsule()
                        .fill(self.color)
                        .frame(
                            height:
                                CGFloat(value / self.maxValue) * geometry.size.height >= 7.0
                                ? CGFloat(value / self.maxValue) * geometry.size.height : 7.0
                        )
                }
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(
            arrayValues: [
                1.0, 2.0, 3.0, 4.0, 5.0, 9.0, 1.0, 2.0, 3.0, 4.0, 5.0, 9.0, 1.0, 2.0, 3.0, 4.0, 5.0, 9.0,
                1.0, 2.0, 3.0, 4.0, 5.0
            ], color: .flatDarkRed)
    }
}
