//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var sheet = SheetState()
    @StateObject private var viewModel = HomeViewViewModel()

    @State private var progress: CGFloat = 0.4
    @State private var isActionSheetPresented: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationView {
            List {
                ListView(header: Text("Main Info")) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                        RectangleData(title: "CFU", data: "\(viewModel.gainedCfu)", color: .flatBlue)
                        RectangleData(title: "Upcoming Exams", data: "\(viewModel.upcomingExams)", color: .flatShakespeare)
                        RectangleData(title: "Average", data: "\(viewModel.average.twoDecimalPrecision)", color: .green)
                        RectangleData(title: "Due Assignments", data: "\(viewModel.dueAssignments)", color: .orange)
                    })
                }
                Section(header: Text("Categories")) {
                    NavigationLink(destination: MarksView()) {
                        Label(title: {
                            Text("Your Marks")
                                .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                        }) {
                            CircledIcon(color: .flatOrange) {
                                Image(systemName: "checkmark.seal.fill")
                            }
                        }.padding(.vertical, 10)
                    }
                    NavigationLink(destination: StatsView()) {
                        Label(title: {
                            Text("Statistics")
                                .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                        }) {
                            CircledIcon(color: .flatHurricane) {
                                Image(systemName: "chart.bar.doc.horizontal.fill")
                                    .font(.system(size: 18.0))
                            }
                        }.padding(.vertical, 10)
                    }
                }.listRowBackground(Color("cardBackground"))
                Section(header: Text("Tools")) {
                    NavigationLink(destination: AverageDeltaTool()) {
                        Label(title: {
                            Text("Average Delta Tool")
                                .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                        }) {
                            CircledIcon(color: .flatBlue) {
                                Image(systemName: "divide.circle.fill")
                                    .font(.system(size: 20.0))
                            }
                        }.padding(.vertical, 10)
                    }
                }.listRowBackground(Color("cardBackground"))
            }
            .onAppear {
                UIScrollView.appearance().backgroundColor = UIColor(named: "background")
                UITableView.appearance().backgroundColor = UIColor(named: "background")
                UITableView.appearance().separatorStyle = .none
            }
            .listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $sheet.isShowing, content: sheetContent)

            .navigationBarTitle("Home", displayMode: .automatic)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            sheet.state = .settings
                        }, label: {
                            Image(systemName: "gear").font(.system(size: 20))
                        })
                    }
            )
        }
    }

    @ViewBuilder
    private func sheetContent() -> some View {
        switch sheet.state {
        case .settings:
            SettingsView()
        default:
            EmptyView()
        }
    }
}

fileprivate class SheetState: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var state: SheetContent = .none {
        didSet {
            isShowing = state != .none
        }
    }
}


fileprivate enum SheetContent {
    case none
    case settings
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .dark)
            .environment(\.locale, .init(identifier: "it"))
    }
}
