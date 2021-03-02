//
//  StatsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewViewModel()

    var body: some View {
        dataContent()
        .onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        
        .navigationBarTitle("Statistics")
    }
    
    @ViewBuilder
    func dataContent() -> some View {
        // TODO change condition on if statement
        if viewModel.courses.count > 0 {
            List {
                Section(header: Text("Main Info")) {
                    ListItem(itemDescription: "Total courses", itemValue: viewModel.totalCourses)
                    ListItem(itemDescription: "Total CFU", itemValue: viewModel.totalCfu)
                    ListItem(itemDescription: "Expected Average", itemValue: viewModel.expectedAverage)
                    ListItem(itemDescription: "Projected graduation grade", itemValue: viewModel.projectedGraduationGrade)
                }.listRowBackground(Color("cardBackground"))

                Section(header: Text("Current statistics")) {
                    ListItem(itemDescription: "Passed exams", itemValue: viewModel.numPassedExams)
                    ListItem(itemDescription: "Gained CFU", itemValue: viewModel.gainedCfu)
                    ListItem(itemDescription: "Current average", itemValue: viewModel.currentAverage)
                    ListItem(itemDescription: "Current graduation grade", itemValue: viewModel.currentProjectedGraduationGrade)
                }.listRowBackground(Color("cardBackground"))

                Section(header: Text("Exams passed")) {
                    ListItem(itemDescription: "As expected", itemValue: viewModel.asExpected)
                    ListItem(itemDescription: "Better than expected", itemValue: viewModel.betterThanExpected)
                    ListItem(itemDescription: "Worse than expected", itemValue: viewModel.worseThanExpected)
                }.listRowBackground(Color("cardBackground"))
                
                if viewModel.passedExams.count > 0 {
                    Section(header: Text("Other")) {
                        PieChart(
                            data: .constant(viewModel.pieChartPassedCoursesMarks.values.map { Double($0) }),
                            labels: .constant(viewModel.pieChartPassedCoursesMarks.keys.map { String($0) }),
                            colors: Color.gradientsPalette.shuffled(), borderColor: .white
                        )
                        .frame(height: 250, alignment: .center)
                    }
                    .listRowBackground(Color.background)
                }
            }
            .listStyle(InsetGroupedListStyle())
        } else {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    Image(systemName: "xmark.seal.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.flatRed)
                    Text("No data available to show").font(.system(size: 20.0, weight: .regular, design: .rounded))
                }
            }
        }
    }
}

struct ListItem: View {
    var itemDescription: String
    var itemValue: Double

    var body: some View {
        HStack {
            Text(LocalizedStringKey(itemDescription))
                .font(.system(size: 16.0, weight: .regular, design: .rounded))
            Spacer()
            Text(itemValue == floor(itemValue) ? "\(Int(itemValue))" : "\(itemValue.twoDecimalPrecision)")
                .font(.system(size: 20.0, weight: .semibold, design: .rounded))
        }
        .padding(.vertical, 7)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environment(\.colorScheme, .dark)
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
