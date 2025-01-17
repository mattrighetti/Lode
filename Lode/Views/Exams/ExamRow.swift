//
//  ExamRow.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamRow: View {
    var exam: Exam
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color(hex: exam.color)!)
                
                VStack {
                    Text(exam.dayString)
                        .font(.system(size: 10.0, weight: .bold, design: .rounded))
                    
                    Text("\(exam.dayInt)")
                        .font(.system(size: 25.0, weight: .bold, design: .rounded))
                    
                    Text(exam.monthString)
                        .font(.system(size: 10.0, weight: .bold, design: .rounded))
                    
                }.foregroundColor(.white)
                
            }.frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(exam.title)
                    .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                
                if exam.daysLeft >= 0 {
                    Text(
                        exam.daysLeft > 0 ?
                            String(format: NSLocalizedString("In %d days", comment: ""), exam.daysLeft)
                            : "Today"
                    )
                    .badgePill(color: .blue)
                    .padding(.top, 10)
                }
            }

            Spacer()
        }
        .card()
    }
    
}

struct ExamRow_Previews: PreviewProvider {
    static var previews: some View {
        let exam = Exam()
        exam.date = Date()
        exam.title = "This is a title"
        exam.color = "#AABBFFFF"
        
        return List {
            ExamRow(exam: exam)
        }
        .environment(\.colorScheme, .dark)
    }
}
