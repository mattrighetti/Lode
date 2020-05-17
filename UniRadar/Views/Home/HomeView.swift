//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    init(viewModel: ViewModel) {
        UIScrollView.appearance().backgroundColor = UIColor(named: "background")
        self.viewModel = viewModel
    }

    @ObservedObject var viewModel: ViewModel
    
    @State var progress: CGFloat = 0.4
    @State var markViewActive: Bool = false
    @State var statsViewActive: Bool = false
    @State var otherViewActive: Bool = false
    @State var isActionSheetPresented: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                // MARK: - CardDeck Section
                HomeSection(sectionTitle: "Main Info") {
                    CardStack(viewModel: self.viewModel)
                        .padding(.horizontal, 25)
                }
                .padding(.bottom)
                .frame(height: 450)
                
                // MARK: - Categories Section
                HomeSection(sectionTitle: "Categories") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            NavigationLink(destination: MarksView(courses: self.viewModel.courses), isActive: self.$markViewActive) {
                                CategoriesCard(label: "Mark", imageName: "checkmark.seal")
                            }.buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: StatsView(viewModel: self.viewModel), isActive: self.$statsViewActive) {
                                CategoriesCard(label: "Stats", imageName: "checkmark")
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 25)
                    }
                }
                .padding(.bottom)
            }

            .navigationBarTitle("Home", displayMode: .automatic)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            print("Added element")
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
        }.actionSheet(isPresented: $isActionSheetPresented) {
            ActionSheet(title: Text("Choose an action").font(.title), message: nil, buttons: [
                .default(Text("Add Exam"), action: { print("Add Exam") }),
                .default(Text("Add Reminder"), action: { print("Add Reminder") }),
                .cancel()
            ])
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
            .previewDevice("iPhone Xs")
            .environment(\.colorScheme, .dark)
    }
}
