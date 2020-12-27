//
//  LodeApp.swift
//  UniRadar
//
//  Created by Mattia Righetti on 27/12/20.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

@main
struct LodeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: delegate.viewModel!, appState: delegate.appState!)
                .environment(\.managedObjectContext, delegate.persistentContainer.viewContext)
        }
    }
}
