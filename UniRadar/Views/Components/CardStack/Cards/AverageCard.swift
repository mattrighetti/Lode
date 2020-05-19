//
//  AverageCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AverageCard: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var expectedAveragePassed: Double {
        let eAverage = self.viewModel.courses.filter({ $0.mark != 0 }).map({ Double($0.expectedMark * $0.cfu) }).reduce(0, { $0 + $1 })
        let totalCfuPassed = self.viewModel.courses.filter({ $0.mark != 0 }).map({ Double($0.cfu) }).reduce(0, { $0 + $1 })
        return eAverage / totalCfuPassed
    }
    
    var sign: String {
        if self.viewModel.average >= self.expectedAveragePassed {
            return "+"
        } else {
            return "-"
        }
    }
    
    var difference: Double {
        if self.viewModel.average >= self.expectedAveragePassed {
            return self.viewModel.average - self.expectedAveragePassed
        } else {
            return self.expectedAveragePassed - self.viewModel.average
        }
    }
    
    var isAverageBiggerThanExpected: Bool {
        return self.viewModel.average >= self.expectedAveragePassed
    }
    
    var color: Color {
        if self.isAverageBiggerThanExpected {
            return .green
        } else {
            return .red
        }
    }
    
    var emoji: String {
        if self.sign == "+" {
            switch self.difference {
            case 1...:
                return "🤯"
            case 0.1..<1:
                return "🤩"
            case 0..<0.1:
                return "👌🏻"
            default:
                return ""
            }
        } else {
            return "☹️"
        }
    }
    
    var body: some View {
        VStack {
            if !self.viewModel.courses.isEmpty {
                Group {
                    Text("\(self.viewModel.average.twoDecimalPrecision)")
                        .foregroundColor(self.color)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .padding()
                    
                    HStack {
                        Text("\(self.sign) \(self.difference.twoDecimalPrecision)").foregroundColor(self.color)
                        Text("than expected")
                        Text(emoji)
                    }
                }
            } else {
                VStack {
                    Text("Add a course")
                    Text("to see something useful 😉")
                }
            }
        }
        .modifier(BorderBox(color: self.isAverageBiggerThanExpected ? .green : .red))
        .background(Color("cardBackground"))
    }
}

struct AverageCard_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        AverageCard(viewModel: ViewModel(context: context!))
    }
}
