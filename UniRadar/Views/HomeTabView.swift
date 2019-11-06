//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/10/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeTabView: View {
    
    @State private var showLandingView: Bool = true
    
    var body: some View {
        TabView {
            
            HomeView().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Statistics").tabItem {
                Image(systemName: "square.stack.3d.down.right")
                Text("Statistics")
            }
            
            Text("Marks").tabItem {
                Image(systemName: "checkmark.seal")
                Text("Marks")
            }
            
            Text("Reminders").tabItem {
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
            
            HomeTabView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)"))
            .previewDisplayName("iPad Pro")
        }
    }
}
