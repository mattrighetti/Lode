//
//  AverageCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AverageCard: View {
    @EnvironmentObject var viewModel: HomeViewViewModel
    
    var body: some View {
        VStack {
            if !viewModel.courses.isEmpty {
                Group {
                    Text("\(viewModel.average.twoDecimalPrecision)")
                        .foregroundColor(viewModel.color)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .padding()
                    
                    HStack {
                        Text("\(viewModel.sign) \(viewModel.difference.twoDecimalPrecision)").foregroundColor(viewModel.color)
                        Text("than expected")
                        Text(viewModel.emoji)
                    }
                }
            } else {
                VStack {
                    Text("Add a course")
                    Text("to see something useful 😉")
                }
            }
        }
        .borderBox(color: viewModel.isAverageBiggerThanExpected ? .green : .red)
        .background(Color("cardBackground"))
    }
}

struct AverageCard_Previews: PreviewProvider {
    static var previews: some View {
        AverageCard()
    }
}
