//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/10/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeTabView: View {
    
    @State private var showLandingView: Bool = false
    
    var body: some View {
        TabView {
            
            HomeView().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            StatisticsView().tabItem {
                Image(systemName: "square.stack.3d.down.right")
                Text("Statistics")
            }
            
            Text("Marks").tabItem {
                Image(systemName: "checkmark.seal")
                Text("Marks")
            }
            
            ReminderView().tabItem {
                Image(systemName: "calendar.badge.plus")
                Text("Reminders")
            }
                    
            Text("Info Tab").tabItem {
                Image(systemName: "doc.plaintext")
                Text("Info")
            }
        }.edgesIgnoringSafeArea(.top)
        
        .sheet(isPresented: $showLandingView, content: {
            LandingView(isCardShown: self.$showLandingView)
        })
    }
    
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeTabView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}
