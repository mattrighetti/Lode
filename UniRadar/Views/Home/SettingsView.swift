//
//  SettingsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 17/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var totalCfu: Int = 180
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total CFU")) {
                    Stepper("\(totalCfu)", value: self.$totalCfu, in: 0...300)
                        .disabled(true)
                        .listRowBackground(Color("cardBackground"))
                }
                
                Section(header: Text("Appearance")) {
                    NavigationLink(destination: Text("Feature not available yet"), label: {
                        Text("Accent Color")
                    }).disabled(true).listRowBackground(Color("cardBackground"))
                    NavigationLink(destination: Text("Feature not available yet"), label: {
                        Text("App Icon")
                    }).disabled(true).listRowBackground(Color("cardBackground"))
                }
                
                Section(footer: Text("")) {
                    NavigationLink(destination: Text("Matth"), label: {
                        Text("About")
                    }).disabled(true).listRowBackground(Color("cardBackground"))
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .onAppear {
                self.totalCfu = self.viewModel.totalCfu
            }
            
            .navigationBarTitle("Settings")
        }
    }
}

struct AboutView: View {
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            Image("AppIcon")
        }
    }
}

extension Bundle {
    public var icon: String? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return lastIcon
        }
        return nil
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
//        SettingsView(viewModel: ViewModel(context: .init(concurrencyType: .mainQueueConcurrencyType))).colorScheme(.dark)
        AboutView().colorScheme(.dark)
    }
}
