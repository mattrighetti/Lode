//
//  StatsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {

                HomeSection(sectionTitle: "Main Info") {
                    ZStack {
                        Color("cardBackground")
                        VStack {
                            MainInfoRow(infoName: "Total Exams", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 15, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Total CFU", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Expected Average", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Projected Graduation Score", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 15, trailing: 10))
                        }
                    }
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }

                HomeSection(sectionTitle: "Current statistics") {
                    ZStack {
                        Color("cardBackground")
                        VStack {
                            MainInfoRow(infoName: "Passed Exams", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 15, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Gained CFU", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Current Average", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Current Graduation Score", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 15, trailing: 10))
                        }
                    }
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }

                HomeSection(sectionTitle: "Exams Passed") {
                    ZStack {
                        Color("cardBackground")
                        VStack {
                            MainInfoRow(infoName: "As Expected", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 15, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "More than expected", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            Divider()
                            MainInfoRow(infoName: "Worse than expected", iconName: "nul", value: 22)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 15, trailing: 10))

                        }
                    }
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }

                HomeSection(sectionTitle: "Latest Marks") {
                    ZStack {
                        Color("cardBackground")
                        BarChartView(
                            arrayValues: [18, 19, 30, 28, 22, 22, 25, 26, 28, 28, 26], color: .flatDarkRed
                        ).padding()
                    }.frame(height: 300, alignment: .center)
                }

                HomeSection(sectionTitle: "Average Path") {
                    ZStack {
                        Color("cardBackground")
                        BarChartView(
                            arrayValues: [18, 19, 30, 28, 22, 22, 25, 26, 28, 28, 26], color: .flatDarkRed
                        ).padding()
                    }.frame(height: 300, alignment: .center)
                }

            }

            .navigationBarTitle("Statistics")
        }
    }
}

struct MainInfoRow: View {

    var infoName: String
    var iconName: String
    var value: Int

    var body: some View {
        HStack {
            Image(systemName: "book")
            VStack {
                Text(infoName)
            }
            Spacer()
            Text("\(value)")
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView().environment(\.colorScheme, .dark)
    }
}
