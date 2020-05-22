//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: ViewModel
    
    @State var progress: CGFloat = 0.4
    @State var markViewActive: Bool = false
    @State var statsViewActive: Bool = false
    @State var toolsViewActive: Bool = false
    @State var isActionSheetPresented: Bool = false
    @State var sheetMenu: SheetMenu?
    @State var sheetMenuShown: Bool = false
    @State var showAlert: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                // MARK: - CardDeck Section
                HomeSection(sectionTitle: NSLocalizedString("Main Info", comment: "")) {
                    CardStack(viewModel: self.viewModel)
                        .padding(.horizontal, 25)
                }
                .padding(.bottom)
                .frame(height: 450)
                
                // MARK: - Categories Section
                HomeSection(sectionTitle: NSLocalizedString("Categories", comment: "")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            NavigationLink(destination: MarksView(courses: self.viewModel.courses), isActive: self.$markViewActive) {
                                CategoriesCard(label: NSLocalizedString("Marks", comment: ""), imageName: "checkmark.seal")
                            }.buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: StatsView(viewModel: self.viewModel), isActive: self.$statsViewActive) {
                                CategoriesCard(label: NSLocalizedString("Stats", comment: ""), imageName: "checkmark")
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 25)
                    }
                }
                
                // MARK: - Categories Section
                HomeSection(sectionTitle: NSLocalizedString("Tools", comment: "")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            NavigationLink(destination: AverageDeltaTool(viewModel: self.viewModel), isActive: self.$toolsViewActive) {
                                CategoriesCard(label: NSLocalizedString("Avg Delta Calculator", comment: ""), imageName: "divide.circle")
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 25)
                    }
                }
                .padding(.bottom)
            }
            .sheet(isPresented: self.$sheetMenuShown) {
                self.sheetMenu!.contentView
            }

            .navigationBarTitle("Home", displayMode: .automatic)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            self.toggle(menu: .settings(viewModel: self.viewModel))
                        }, label: {
                            Image(systemName: "gear").font(.system(size: 20))
                        })
                    },
                trailing: HStack {
                    Button(action: {
                        self.isActionSheetPresented.toggle()
                    }, label: {
                        Image(systemName: "plus.circle").font(.system(size: 20))
                    })

                }
            )
        }
        .alert(isPresented: self.$showAlert) {
            Alert(
                title: Text("No course is present"),
                message: Text("You must first add a course before creating exams"),
                dismissButton: .cancel(Text("Ok"))
            )
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
            ActionSheet(title: Text("Choose an action").font(.title), message: nil, buttons: [
                .default(Text("Add exam"), action: {
                    self.toggle(
                        menu: .examform(courses: self.viewModel.courses.filter({ $0.mark == 0 }).map({ $0.name! }) )
                    )
                }),
                .default(Text("Add assignment"), action: {
                    self.toggle(menu: .assignmentform)
                }),
                .default(Text("Add course"), action: {
                    self.toggle(menu: .courseform)
                }),
                .cancel()
            ])
        }
    }
    
    private func toggle(menu: SheetMenu) {
        if menu == .examform(courses: []) {
            if self.viewModel.courses.filter({ $0.mark == 0 }).map({ $0.name! }).isEmpty {
                self.showAlert.toggle()
            } else {
                self.sheetMenu = menu
                self.sheetMenuShown.toggle()
            }
        } else {
            self.sheetMenu = menu
            self.sheetMenuShown.toggle()
        }
    }
    
    enum SheetMenu: Equatable {
        case settings(viewModel: ViewModel)
        case examform(courses: [String])
        case assignmentform
        case courseform
        
        var contentView: AnyView {
            switch self {
            case .settings(let viewModel):
                return AnyView( SettingsView(viewModel: viewModel) )
            case .examform(let courses):
                return AnyView( ExamForm(courses: courses) )
            case .assignmentform:
                return AnyView( ReminderForm() )
            case .courseform:
                return AnyView( CourseForm() )
            }
            
        }
        
        static func == (lhs: SheetMenu, rhs: SheetMenu) -> Bool {
            switch (lhs, rhs) {
            case (.settings, .settings):
                return true
            case (.examform(courses: _), .examform(courses: _)):
                return true
            case (.assignmentform, .assignmentform):
                return true
            case (.courseform, .courseform):
                return true
            default:
                return false
            }
        }
    }
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
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        HomeView(viewModel: ViewModel(context: context!))
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .dark)
            .environment(\.locale, .init(identifier: "it"))
    }
}
