//
//  AverageCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AverageCard: View {

    @AppStorage("laudeValue") var laudeValue: Int = 30

    // TODO apply logic in ViewModel
    @Binding var courses: [Course]
    @Binding var average: Double
    
    var expectedAveragePassed: Double {
        let eAverage = courses.filter({ $0.mark != 0 }).map({
            Double($0.cfu) * (Bool(truncating: $0.expectedLaude!) ? Double(laudeValue) : Double($0.expectedMark))
        }).reduce(0, { $0 + $1 })
        
        let totalCfuPassed = courses.filter({ $0.mark != 0 }).map({
            Double($0.cfu)
        }).reduce(0, { $0 + $1 })
        return (eAverage / totalCfuPassed).isNaN ? 0.0 : eAverage / totalCfuPassed
    }
    
    var sign: String {
        if average >= expectedAveragePassed {
            return "+"
        } else {
            return "-"
        }
    }
    
    var difference: Double {
        if average >= expectedAveragePassed {
            return average - expectedAveragePassed
        } else {
            return expectedAveragePassed - average
        }
    }
    
    var isAverageBiggerThanExpected: Bool { average >= expectedAveragePassed }
    
    var color: Color {
        if isAverageBiggerThanExpected {
            return .green
        } else {
            return .red
        }
    }
    
    var emoji: String {
        if sign == "+" {
            switch difference {
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
            if !courses.isEmpty {
                Group {
                    Text("\(average.twoDecimalPrecision)")
                        .foregroundColor(color)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .padding()
                    
                    HStack {
                        Text("\(sign) \(difference.twoDecimalPrecision)").foregroundColor(color)
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
        .borderBox(color: isAverageBiggerThanExpected ? .green : .red)
        .background(Color("cardBackground"))
    }
}

struct AverageCard_Previews: PreviewProvider {
    static var previews: some View {
        AverageCard(courses: .constant([Course]()), average: .constant(29.0))
    }
}
