//
//  SettingsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 17/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("totalCfu") var totalCfu: Int = 180
    @AppStorage("laudeValue") var laudeValue: Int = 30
    
    private var totalCfuProxy: Binding<Int> {
        Binding<Int>(get: {
            totalCfu
        }, set: {
            self.totalCfu = $0
            totalCfu = $0
        })
    }
    
    private var laudeValueProxy: Binding<Int> {
        Binding<Int>(get: {
            laudeValue
        }, set: {
            self.laudeValue = $0
            laudeValue = $0
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total CFU")) {
                    Stepper("\(totalCfu)", value: totalCfuProxy, in: 0...300)
                }
                
                Section(header: Text("Laude value")) {
                    Stepper("\(laudeValue)", value: laudeValueProxy, in: 30...35)
                }
                
                Section(footer: Text("")) {
                    NavigationLink(destination: AboutView(), label: {
                        Text("About")
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
                .colorScheme(.dark)
    }
}
