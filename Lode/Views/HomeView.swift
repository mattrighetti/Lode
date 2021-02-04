//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject private var sheet = SheetState()
    @StateObject private var viewModel = HomeViewViewModel()

    @State private var progress: CGFloat = 0.4
    @State private var markViewActive: Bool = false
    @State private var statsViewActive: Bool = false
    @State private var toolsViewActive: Bool = false
    @State private var isActionSheetPresented: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                // MARK: - CardDeck Section
                HomeSection(sectionTitle: NSLocalizedString("Main Info", comment: "")) {
                    CardStack()
                        .padding(.horizontal, 25)
                        .environmentObject(viewModel)
                }
                .padding(.bottom)
                .frame(height: 450)

                // MARK: - Categories Section
                HomeSection(sectionTitle: NSLocalizedString("Categories", comment: "")) {
                    VStack(alignment: .leading) {
                        NavigationLink(destination: MarksView(), isActive: self.$markViewActive) {
                            Label(title: {
                                Text("Your Marks").font(.system(size: 20.0, weight: .semibold, design: .rounded))
                            }) {
                                Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.flatGreen)
                                        .font(.system(size: 20.0))
                            }
                        }.buttonStyle(PlainButtonStyle())
                        Divider()
                        NavigationLink(destination: StatsView(), isActive: self.$statsViewActive) {
                            Label(title: {
                                Text("Statistics").font(.system(size: 20.0, weight: .semibold, design: .rounded))
                            }) {
                                Image(systemName: "chart.bar.doc.horizontal.fill")
                                        .foregroundColor(.flatGreen)
                                        .font(.system(size: 20.0))
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }.card()
                    .padding(.horizontal, 25)
                }

                // MARK: - Categories Section
                HomeSection(sectionTitle: NSLocalizedString("Tools", comment: "")) {
                    VStack(alignment: .leading) {
                        NavigationLink(destination: AverageDeltaTool(), isActive: self.$toolsViewActive) {
                            Label(title: {
                                HStack {
                                    Text("Average Delta Tool")
                                        .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                                    Spacer()
                                }
                            }) {
                                Image(systemName: "divide.circle.fill")
                                        .foregroundColor(.flatGreen)
                                        .font(.system(size: 20.0))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }.card()
                    .padding(.horizontal, 25)
                }
                .padding(.bottom)
            }
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
        }.onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
    }

    @ViewBuilder private func sheetContent() -> some View {
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

struct HomeSection<Content>: View where Content: View {
    var sectionTitle: String
    var content: () -> Content

    var body: some View {
        VStack {
            HStack {
                Text("\(sectionTitle)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                Spacer()
            }
            content()
        }
    }
}

struct CategoriesCard: View {
    var label: String
    var imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: imageName)
                .font(.system(size: 20))
                .foregroundColor(.green)
            
            Text(label)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 10, trailing: 80))
        }
        .modifier(CardStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
                .environment(\.locale, .init(identifier: "it"))
            
            HomeView()
                .previewDevice("iPad (7th generation)")
                .environment(\.colorScheme, .dark)
                .environment(\.locale, .init(identifier: "it"))
        }
    }
}