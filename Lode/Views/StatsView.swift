//
//  StatsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = StatsViewViewModel()

    var body: some View {
        List {
            Section(header: Text("Main Info")) {
                ListItem(itemDescription: "Total Courses", itemValue: viewModel.totalCourses)
                ListItem(itemDescription: "Total CFU", itemValue: viewModel.totalCfu)
                ListItem(itemDescription: "Expected Average", itemValue: viewModel.expectedAverage)
                ListItem(itemDescription: "Projected graduation grade", itemValue: viewModel.projectedGraduationGrade)
            }.listRowBackground(Color("cardBackground"))

            Section(header: Text("Current statistics")) {
                ListItem(itemDescription: "Passed exams", itemValue: viewModel.numPassedExams)
                ListItem(itemDescription: "Gained CFU", itemValue: viewModel.gainedCfu)
                ListItem(itemDescription: "Current Average", itemValue: viewModel.currentAverage)
                ListItem(itemDescription: "Current graduation grade", itemValue: viewModel.currentProjectedGraduationGrade)
            }.listRowBackground(Color("cardBackground"))

            Section(header: Text("Exams passed")) {
                ListItem(itemDescription: "As expected", itemValue: viewModel.asExpected)
                ListItem(itemDescription: "Better than expected", itemValue: viewModel.betterThanExpected)
                ListItem(itemDescription: "Worse than expected", itemValue: viewModel.worseThanExpected)
            }.listRowBackground(Color("cardBackground"))
            
            Section(header: Text("Latest marks")) {
                BarChartView(arrayValues: viewModel.barChartData, color: .red)
                    .frame(height: 250, alignment: .center)
                    .padding()
            }.listRowBackground(Color("cardBackground"))
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        .onDisappear {
            // TODO check if needed
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
