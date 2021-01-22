//
//  StatsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(entity: Course.entity(), sortDescriptors: [], animation: .spring())
    private var courses: FetchedResults<Course>

    @FetchRequest(entity: Exam.entity(), sortDescriptors: [], animation: .spring())
    private var exams: FetchedResults<Exam>

    var totalCourses: Double {
        Double(courses.count)
    }

    var totalCfu: Double {
        courses.compactMap { course in Double(course.cfu) }.reduce(0, { $0 + $1 })
    }

    var expectedAverage: Double {
        let markSum = courses.compactMap { course in
            Double(course.expectedMark) * Double(course.cfu)
        }
        .reduce(0, { $0 + $1 })

        return markSum / Double(totalCfu)
    }

    var projectedGraduationGrade: Double {
        expectedAverage * 11.0 / 30.0
    }

    var passedExams: [Course] {
        courses.filter { $0.mark != 0 }
    }

    var numPassedExams: Double {
        Double(passedExams.count)
    }

    var gainedCfu: Double {
        passedExams.compactMap { Double($0.cfu) }.reduce(0, { $0 + $1 })
    }

    var currentAverage: Double {
        let average = passedExams.compactMap { Double($0.cfu) * Double($0.mark) }.reduce(0, { $0 + $1 })
        return average / gainedCfu
    }

    var currentProjectedGraduationGrade: Double {
        currentAverage * 11.0 / 31.0
    }

    var asExpected: Double {
        Double(passedExams.filter { course in course.mark == course.expectedMark }.count)
    }

    var betterThanExpected: Double {
        Double(passedExams.filter { course in course.mark > course.expectedMark }.count)
    }

    var worseThanExpected: Double {
        Double(passedExams.filter { course in course.mark < course.expectedMark }.count)
    }

    var body: some View {
        List {
            Section(header: Text("Main Info")) {
                ListItem(itemDescription: "Total Courses", itemValue: totalCourses)
                ListItem(itemDescription: "Total CFU", itemValue: totalCfu)
                ListItem(itemDescription: "Expected Average", itemValue: expectedAverage)
                ListItem(itemDescription: "Projected graduation grade", itemValue: projectedGraduationGrade)
            }

            Section(header: Text("Current statistics")) {
                ListItem(itemDescription: "Passed exams", itemValue: numPassedExams)
                ListItem(itemDescription: "Gained CFU", itemValue: gainedCfu)
                ListItem(itemDescription: "Current Average", itemValue: currentAverage)
                ListItem(itemDescription: "Current graduation grade", itemValue: currentProjectedGraduationGrade)
            }

            Section(header: Text("Exams passed")) {
                ListItem(itemDescription: "As expected", itemValue: asExpected)
                ListItem(itemDescription: "Better than expected", itemValue: betterThanExpected)
                ListItem(itemDescription: "Worse than expected", itemValue: worseThanExpected)
            }
            
            Section(header: Text("Latest marks")) {
                BarChartView(arrayValues: courses.filter({ $0.mark != 0 }).map({ Double($0.mark) }), color: .red)
                    .frame(height: 250, alignment: .center)
                    .padding()
            }
            
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        .onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
        
        .navigationBarTitle("Statistics")
    }
}

struct ListItem: View {
    var itemDescription: String
    var itemValue: Double

    var body: some View {
        HStack {
            Text(itemDescription)
            Spacer()
            Text(
                itemValue == floor(itemValue) ?
                    "\(Int(itemValue))" :
                    "\(itemValue.twoDecimalPrecision)"
            )
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environment(\.colorScheme, .dark)
        .previewDevice("iPad Pro (12.9-inch)")
    }
}
