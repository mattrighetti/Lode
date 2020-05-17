//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import CoreData

struct MainView: View {

    @ObservedObject var viewModel: ViewModel
    
    @State var introduced: Bool = true
    @State var showSplashscreen: Bool = false

    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CoursesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "archivebox")
                    Text("Courses")
                }
            
            ExamsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Exams")
                }
            
            RemindersView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "pin")
                    Text("Reminders")
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
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        MainView(viewModel: ViewModel(context: moc)).colorScheme(.dark).accentColor(Color.red)
    }
}
