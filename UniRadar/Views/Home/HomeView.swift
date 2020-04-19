//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State var progress: CGFloat = 1.0
    
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().backgroundColor = UIColor(named: "background")
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "text")!]

        //Use this if NavigationBarTitle is with displayMode = .inline
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 20) {
                        HStack {
                            Text("Your Info")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                            Spacer()
                        }
                        
                        ZStack {
                            DataCard(headerTitle: "Your cfu", description: "Completion percentage of \n your CFUs") {
                                CircularProgressBar(progress: self.$progress).padding()
                            }
                            .opacity(0.35)
                            .scaleEffect(0.78)
                            .offset(x: 0.0, y: 60.0)
                            .frame(width: 300, height: 300, alignment: .center)
                            
                            DataCard(headerTitle: "Your cfu", description: "Completion percentage of \n your CFUs") {
                                CircularProgressBar(progress: self.$progress).padding()
                            }
                            .opacity(0.6)
                            .scaleEffect(0.95)
                            .offset(x: 0.0, y: 20.0)
                            .frame(width: 300, height: 300, alignment: .center)
                            
                            DataCard(headerTitle: "Exams", description: "You got few exams left") {
                                CircularProgressBar(progress: self.$progress).padding()
                            }
                            .frame(width: 300, height: 300, alignment: .center)
                        }
                        
                    }
                }
                
                .navigationBarTitle("Home")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.colorScheme, .light)
    }
}
