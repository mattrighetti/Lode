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
    
    var courseAcronym: String {
        let splitString = self.course.name!
            .split { $0 == " " }
            .map(String.init)
            .filter { $0 != "and" && $0 != "e" }
        
        return splitString.map({ String($0.first!).uppercased() }).reduce("", +)
    }
    
    var isNameTooLong: Bool {
        return self.course.name!.count > 30
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.gradientsPalette[Int(course.colorRowIndex)][Int(course.colorColIndex)])
                Image(systemName: course.iconName ?? "pencil").foregroundColor(.white).font(.system(size: 30))
            }
            .frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(isNameTooLong ? self.courseAcronym : self.course.name ?? "No name")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    NumberBadge(label: "CFU", value: Int(self.course.cfu), color: .orange)
                    badge()
                }
                .padding(.top, 10)
            }
            .drawingGroup()
            
            Spacer()
        }
        .card()
    }
    
    private func badge() -> some View {
        if self.course.mark != 0 {
            return AnyView( NumberBadge(label: "Final", value: Int(self.course.mark), color: .yellow) )
        } else {
            return AnyView( NumberBadge(label: "Expected", value: Int(self.course.expectedMark), color: .blue) )
        }
    }
    
}

struct NumberBadge: View {
    
    var label: String
    var value: Int
    var laude: Bool {
        if self.value == 31 {
            return true
        }
        return false
    }
    var color: Color
    
    var body: some View {
        HStack {
            Text(label)
            Image(systemName: "\(self.value == 31 ? 30 : self.value).circle")
                .font(.system(size: 20))
            if laude {
                Text("L")
                    .padding(.horizontal, 0)
            }
        }
        .badgePillWithImage(color: color)
    }
}

struct CourseRow_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        let course = Course(context: context!)
        course.name = "Advanced Algorithms and Parallel Programming"
        course.cfu = 5
        course.expectedMark = 28
        course.mark = 30
        return List {
            CourseRow(course: course)
        }.colorScheme(.dark)
    }
}
