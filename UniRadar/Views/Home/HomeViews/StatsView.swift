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
    
    var body: some View {
        List {
            StatsStringListSection(sectionHeader: NSLocalizedString("Main Info", comment: ""), strings: [
                NSLocalizedString("Total courses", comment: ""),
                NSLocalizedString("Total CFU", comment: ""),
                NSLocalizedString("Expected Average", comment: ""),
                NSLocalizedString("Projected graduation grade", comment: "")
            ], values: [
                Double(self.viewModel.courses.count),
                Double(self.viewModel.totalCfu),
                self.viewModel.expectedAverage,
                self.viewModel.expectedGraduationGrade
            ])
            
            StatsStringListSection(sectionHeader: NSLocalizedString("Current statistics", comment: ""), strings: [
                NSLocalizedString("Passed exams", comment: ""),
                NSLocalizedString("Gained CFU", comment: ""),
                NSLocalizedString("Current average", comment: ""),
                NSLocalizedString("Current graduation grade", comment: "")
            ], values: [
                Double(self.viewModel.passedExams),
                Double(self.viewModel.gainedCfu),
                self.viewModel.average,
                self.viewModel.projectedGraduationGrade
            ])
            
            StatsStringListSection(sectionHeader: NSLocalizedString("Exams Passed", comment: ""), strings: [
                NSLocalizedString("As Expected", comment: ""),
                NSLocalizedString("More than expected", comment: ""),
                NSLocalizedString("Less than expected", comment: "")
            ], values: [
                Double(self.viewModel.passedAsExpected),
                Double(self.viewModel.passedBetterThanExpected),
                Double(self.viewModel.passedWorseThanExpected)
            ])
            
            Section(header: Text("Latest marks").modifier(SectionTitle())) {
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
