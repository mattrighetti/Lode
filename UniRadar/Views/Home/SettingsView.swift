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
    @State var laudeValue: Int = 30
    
    private var totalCfuProxy: Binding<Int> {
        Binding<Int>(get: {
            self.totalCfu
        }, set: {
            self.totalCfu = $0
            self.viewModel.totalCfu = $0
        })
    }
    
    private var laudeValueProxy: Binding<Int> {
        Binding<Int>(get: {
            self.laudeValue
        }, set: {
            self.laudeValue = $0
            self.viewModel.laudeValue = $0
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total CFU")) {
                    Stepper("\(self.totalCfu)", value: self.totalCfuProxy, in: 0...300)
                }.listRowBackground(Color.cardBackground)
                
                Section(header: Text("Laude value")) {
                    Stepper("\(self.laudeValue)", value: self.laudeValueProxy, in: 30...35)
                }.listRowBackground(Color.cardBackground)
                
                Section(footer: Text("")) {
                    NavigationLink(destination: AboutView(), label: {
                        Text("About")
                    })
                }.listRowBackground(Color.cardBackground)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .onAppear {
                self.totalCfu = self.viewModel.totalCfu
                self.laudeValue = self.viewModel.laudeValue
            }
            .onDisappear {
                self.viewModel.storeInUserDefaults()
                print("Saving...")
            }
            
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        SettingsView(viewModel: ViewModel(context: context!)).colorScheme(.dark)
    }
}
