//
//  CourseRow.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CourseRow: View {
    var course: Course

    private var courseAcronym: String {
        let splitString = course.name
            .split { $0 == " " }
            .map(String.init)
            .filter { $0 != "and" && $0 != "e" }
        
        return splitString.map({ String($0.first!).uppercased() }).reduce("", +)
    }
    
    private var isNameTooLong: Bool {
        course.name.count > 30
    }
    
    private var finalMarkColor: Color? {
        if course.mark != 0 {
            if course.mark >= course.expectedMark {
                return .green
            } else {
                return .red
            }
        }
        return nil
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color(hex: course.color)!)
                Image(systemName: course.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
            .frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(isNameTooLong ? self.courseAcronym : course.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                VStack(alignment: .leading, spacing: 3.0) {
                    VerticalLineBadge(label: "CFU", value: Int(course.cfu), color: .orange)
                    badge()
                }
            }
            
            Spacer()
        }
        .card()
    }

    @ViewBuilder
    private func badge() -> some View {
        if course.mark != 0 {
            VerticalLineBadge(label: "Final", value: Int(course.mark), color: finalMarkColor!)
        } else {
            VerticalLineBadge(label: "Expected", value: Int(course.expectedMark), color: .blue)
        }
    }
    
}

struct VerticalLineBadge: View {
    var label: String
    var value: Int
    var laude: Bool {
        if value == 31 {
            return true
        }
        return false
    }
    var color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 3, height: 15, alignment: .center)
                .foregroundColor(color)
            Text(label)
                .fontWeight(.regular)
            Text("\(value == 31 ? 30 : value)\(laude ? "L" : "")")
                .fontWeight(.semibold)
        }
    }
}

struct CourseRow_Previews: PreviewProvider {
    static var previews: some View {
        let course = Course()
        course.name = "Advanced Algorithms and Parallel Programming"
        course.cfu = 5
        course.expectedMark = 28
        course.mark = 30
        return List {
            CourseRow(course: course)
        }.colorScheme(.dark)
    }
}
