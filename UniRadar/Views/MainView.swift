//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State var introduced: Bool = true
    @State var showSplashscreen: Bool = true
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            RemindersView()
                .tabItem {
                    Image(systemName: "pin")
                    Text("Reminders")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "function")
                    Text("Stats")
                }
        }.sheet(isPresented: $showSplashscreen) {
            SplashScreenView()
        }.onAppear {
            if !self.introduced {
                self.showSplashscreen.toggle()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.colorScheme, .light)
    }
}
