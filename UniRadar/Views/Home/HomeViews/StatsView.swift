//
//  StatsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        UIScrollView.appearance().backgroundColor = UIColor(named: "background")
    }
    
    var body: some View {
        List {
            StatsStringListSection(sectionHeader: "Main Info", strings: [
                "Total Courses",
                "Total CFU",
                "Expected Average",
                "Projected Graduation Grade"
            ], values: [
                Double(self.viewModel.courses.count),
                Double(self.viewModel.totalCfu),
                self.viewModel.expectedAverage,
                self.viewModel.expectedGraduationGrade
            ])
            
            StatsStringListSection(sectionHeader: "Current statistics", strings: [
                "Passed Exams",
                "Gained CFU",
                "Current Average",
                "Current Graduation Grade"
            ], values: [
                Double(self.viewModel.passedExams),
                Double(self.viewModel.gainedCfu),
                self.viewModel.average,
                self.viewModel.projectedGraduationGrade
            ])
            
            StatsStringListSection(sectionHeader: "Exams Passed", strings: [
                "As Expected",
                "More than expected",
                "Worse than expected"
            ], values: [
                Double(self.viewModel.passedAsExpected),
                Double(self.viewModel.passedBetterThanExpected),
                Double(self.viewModel.passedWorseThanExpected)
            ])
            
            Section(header: Text("Latest Marks").modifier(SectionTitle())) {
                BarChartView(arrayValues: self.viewModel.courses.map { Double($0.mark) }, color: .red)
                    .frame(height: 250, alignment: .center)
                    .padding()
                    .listRowBackground(Color("cardBackground"))
            }
            
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        
        .navigationBarTitle("Statistics")
    }
}

struct StatsStringListSection: View {
    
    var sectionHeader: String
    var strings: [String]
    var values: [Double]
    
    var body: some View {
        Section(header: Text(sectionHeader).modifier(SectionTitle())) {
            ForEach(strings.indices) { index in
                VStack {
                    HStack {
                        Text(self.strings[index])
                        Spacer()
                        Text(
                            self.values[index] == floor(self.values[index]) ?
                            "\(Int(self.values[index]))" :
                            "\(self.values[index].twoDecimalPrecision)"
                        ).padding(10)
                    }
                }
                .listRowBackground(Color("cardBackground"))
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        StatsView(viewModel: ViewModel(context: context!)).environment(\.colorScheme, .dark)
    }
}
