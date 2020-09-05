//
//  ReminderDescription.swift
//  UniRadar
//
//  Created by Mattia Righetti on 23/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CourseDescriptionPage: View {
    
    var course: Course?
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            Group {
                if self.course != nil {
                    VStack {
                        VStack {
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(Color.gradientsPalette[Int(self.course!.colorRowIndex)][Int(self.course!.colorColIndex)])

                                VStack {
                                    Image(systemName: self.course!.iconName!)
                                        .font(.system(size: 25.0, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }.frame(width: 100, height: 100, alignment: .center)
                            Text(self.course!.name!).font(.system(.largeTitle, design: .rounded)).bold()
                        }
                        .padding(.bottom, 20)
                        
                        VStack {
                            HStack {
                                Spacer()
                                HStack {
                                    VStack {
                                        Text("\(self.course!.expectedMark)")
                                            .font(.system(.title, design: .rounded))
                                            .fontWeight(.bold)
                                        
                                        Text("Expected").modifier(BadgePillStyle(color: .blue))
                                    }.frame(width: 100)
                                    
                                    Divider().frame(height: 100)
                                    
                                    VStack {
                                        Text("\(self.course!.mark == 0 ? "?" : String(self.course!.mark))")
                                            .font(.system(.title, design: .rounded))
                                            .fontWeight(.bold)
                                        
                                        Text("Final").modifier(BadgePillStyle(color: .green))
                                    }.frame(width: 100)
                                }.modifier(BorderBox(color: Color.background))
                                Spacer()
                            }
                        }
                        .card()
                        
                        Spacer()
                    }.padding()
                } else {
                    Text("Select a course")
                }
            }
        }
    }
}

struct CourseDescriptionPage_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        let course = Course(context: context!)
        course.cfu = 5
        course.colorColIndex = 0
        course.colorRowIndex = 0
        course.expectedMark = 19
        course.laude = true
        course.expectedLaude = false
        course.iconName = "pencil"
        course.id = UUID()
        course.mark = 31
        course.name = "Analisi 1"
        
        return Group {
            CourseDescriptionPage(course: course)
                .colorScheme(.dark)
                .previewDevice("iPhone 11")
            
            CourseDescriptionPage(course: course)
                .colorScheme(.dark)
                .previewDevice("iPad (7th generation)")
        }
    }
}
