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
                }.listRowBackground(Color("cardBackground"))
                
                Section(header: Text("Appearance")) {
                    NavigationLink(destination: Text("Feature not available yet"), label: {
                        Text("Accent Color")
                    }).disabled(true)
                    NavigationLink(destination: Text("Feature not available yet"), label: {
                        Text("App Icon")
                    }).disabled(true)
                }.listRowBackground(Color("cardBackground"))
                
                Section(footer: Text("")) {
                    NavigationLink(destination: AboutView(), label: {
                        Text("About")
                    })
                }.listRowBackground(Color("cardBackground"))
            }
            .singleSeparator()
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .onAppear {
                self.totalCfu = self.viewModel.totalCfu
            }
            
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: ViewModel(context: .init(concurrencyType: .mainQueueConcurrencyType))).colorScheme(.dark)
    }
}
