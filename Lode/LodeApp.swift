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
                    UITableView.appearance().backgroundColor = .clear // tableview background
                    UITableViewCell.appearance().backgroundColor = .clear // cell background
                }
        }
    }
}
