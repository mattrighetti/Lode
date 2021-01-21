//
//  LodeApp.swift
//  Lode
//
//  Created by Mattia Righetti on 21/01/21.
//

import SwiftUI

@main
struct LodeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    UIScrollView.appearance().backgroundColor = UIColor(named: "background")
                    UITableView.appearance().backgroundColor = UIColor(named: "background")
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
