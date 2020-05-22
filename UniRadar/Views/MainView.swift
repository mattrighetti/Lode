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
    @ObservedObject var appState: AppState
    
    @State var showSheet: Bool = false

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
                    Text("Assignments")
                }
        }
        .sheet(
            isPresented: $showSheet,
            onDismiss: {
                print("Dismissed", !self.appState.firstAccess, self.appState.initialSetup ?? false)
                if self.appState.firstAccess {
                    self.appState.firstAccess = false
                    self.showSheet.toggle()
                    return
                }
                
                if !self.appState.firstAccess, !self.appState.initialSetup {
                    self.viewModel.storeInUserDefaults()
                    self.appState.initialSetup = true
                    return
                }
            },
            content: {
                self.sheetContent()
            }
        )
        .onAppear {
            if self.appState.firstAccess {
                self.showSheet.toggle()
            }
            
            if !self.appState.firstAccess, !self.appState.initialSetup {
                self.showSheet.toggle()
            }
        }
    }
    
    func sheetContent() -> AnyView {
        if self.appState.firstAccess {
            return AnyView( SplashScreenView() )
        }
        
        if !self.appState.firstAccess, !self.appState.initialSetup {
            return AnyView( InitialForm(viewModel: self.viewModel) )
        }
        
        return AnyView(EmptyView())
    }
    
}

struct MainView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        MainView(viewModel: ViewModel(context: moc), appState: AppState())
            .colorScheme(.dark).accentColor(Color.red)
            
    }
}
