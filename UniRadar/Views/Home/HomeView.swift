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
    
    init() {
        // Make NavigationView the same color as the background
        UINavigationBar.appearance().backgroundColor = UIColor(named: "background")
        // Make NavigationView the same color as the background
        // NB: This was needed because the largeTitle wasn't updating after applying the code above
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "text")!]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    HomeSection(sectionTitle: "Your Info") {
                        ZStack {
                            DataCard(headerTitle: "Your cfu", description: "Completion percentage of \n your CFUs") {
                                CircularProgressBar(progress: self.$progress).padding()
                            }
                            .opacity(0.6)
                            .scaleEffect(0.85)
                            .offset(x: 0.0, y: 35.0)
                            .frame(width: 300, height: 300, alignment: .center)
                            
                            DataCard(headerTitle: "Exams", description: "You got few exams left") {
                                CircularProgressBar(progress: self.$progress).padding()
                            }
                            .frame(width: 300, height: 300, alignment: .center)
                        }
                    }
                    
                    HomeSection(sectionTitle: "Categories") {
                        ZStack {
                            Color("cardBackground")
                            VStack {
                                NavigationLink(destination: EmptyView(), isActive: self.$markViewActive) {
                                    ListRow(title: "Marks", iconName: "rosette")
                                        .padding(EdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 5))
                                }.buttonStyle(PlainButtonStyle())
                                Divider()
                                NavigationLink(destination: EmptyView(), isActive: self.$statsViewActive) {
                                    ListRow(title: "Statistichs", iconName: "x.squareroot")
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                }.buttonStyle(PlainButtonStyle())
                                Divider()
                                NavigationLink(destination: EmptyView(), isActive: self.$otherViewActive) {
                                    ListRow(title: "Statistichs", iconName: "x.squareroot")
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 15, trailing: 5))
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom)
                }
                
                .navigationBarTitle("Home")
                .navigationBarItems(leading:
                    HStack {
                        Button(action: {
                            print("Added element")
                        }) {
                            Image(systemName: "gear")
                        }
                    }, trailing: HStack {
                        Button(action: {
                            print("Added element")
                        }) {
                            Image(systemName: "plus.circle")
                        }
                                        
                    })
            }
        }
    }
}

struct HomeSection<Content: View>: View {
    
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
        HomeView().environment(\.colorScheme, .dark)
    }
}