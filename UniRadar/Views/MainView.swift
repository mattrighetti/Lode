//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State var introduced: Bool = false
    @State var showSplashscreen: Bool = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "pin")
                    Text("Reminders")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "function")
                    Text("Stats")
                }
        }.onAppear {
            if !self.introduced {
                self.showSplashscreen.toggle()
            }
        }.sheet(isPresented: $showSplashscreen, content: { SplashScreenView() })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.colorScheme, .light)
    }
}
