//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @State var progress: CGFloat = 0.4

    @State var markViewActive: Bool = false
    @State var statsViewActive: Bool = false
    @State var otherViewActive: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {

                // MARK: - CardDeck Section
                HomeSection(sectionTitle: "Your Info") {
                    CardStack()
                        .padding(.horizontal, 25)
                }
                .padding(.bottom)
                .frame(height: 450)
                
                // MARK: - Categories Section
                HomeSection(sectionTitle: "Categories") {
                    ZStack {
                        Color("cardBackground")
                        VStack {
                            NavigationLink(destination: MarksView(), isActive: self.$markViewActive) {
                                ListRow(title: "Marks", iconName: "rosette")
                                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 5))
                            }.buttonStyle(PlainButtonStyle())
                            Divider()
                            NavigationLink(destination: StatsView(), isActive: self.$statsViewActive) {
                                ListRow(title: "Statistics", iconName: "x.squareroot")
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                            }.buttonStyle(PlainButtonStyle())
                            Divider()
                            NavigationLink(destination: EmptyView(), isActive: self.$otherViewActive) {
                                ListRow(title: "Whatever", iconName: "function")
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 15, trailing: 5))
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom)
            }
            .padding(.top)
            .background(Color("background").edgesIgnoringSafeArea(.all))

            .navigationBarTitle("Home", displayMode: .automatic)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            print("Added element")
                        }, label: {
                            Image(systemName: "gear")
                        })
                    },
                trailing: HStack {
                    Button(action: {
                        print("Added element")
                    }, label: {
                        Image(systemName: "plus.circle")
                    })

                }
            )
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

struct ListRow: View {

    var title: String
    var iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName).padding(.horizontal)
            Text(title).font(.headline)
            Spacer()
            Image(systemName: "chevron.right").padding(.trailing)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 8")
            .environment(\.colorScheme, .dark)
    }
}
