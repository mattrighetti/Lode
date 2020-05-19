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
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading) {
                    HStack {
                        HStack {
                            Text("CFU")
                            Image(systemName: "\(self.course.cfu).circle")
                                .font(.system(size: 20))
                        }.modifier(BadgePillWithImageStyle(color: .orange))
                        
                        HStack {
                            Text("Difficulty")
                            Image(systemName: "3.circle")
                                .font(.system(size: 20))
                        }.modifier(BadgePillWithImageStyle(color: .blue))
                    }
                    
                    HStack {
                        HStack {
                            Text("Expected")
                            Image(systemName: "\(self.course.expectedMark).circle")
                                .font(.system(size: 20))
                        }.modifier(BadgePillWithImageStyle(color: .blue))
                        
                        if self.course.mark != 0 {
                            HStack {
                                Text("Final")
                                Image(systemName: "\(self.course.mark).circle")
                                    .font(.system(size: 20))
                            }.modifier(BadgePillWithImageStyle(color: .yellow))
                        }
                    }
                }
            }
            Spacer()
        }
        .modifier(CardStyle())
    }
}

struct CourseRow_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        let course = Course(context: context!)
        course.name = "Advanced Algorithms and Parallel Programming"
        course.cfu = 5
        course.expectedMark = 28
        course.mark = 28
        return List {
            CourseRow(course: course)
        }.colorScheme(.dark)
    }
}
