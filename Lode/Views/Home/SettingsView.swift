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
                Section(header: Text("App settings")) {
                    Stepper(value: totalCfuProxy, in: 0...300) {
                        VStack(alignment: .leading) {
                            Text("Total CFU:").font(.system(size: 15.0, weight: .semibold))
                            Text("\(totalCfu)").font(.system(size: 25.0, design: .rounded))
                        }
                    }
                    Stepper(value: laudeValueProxy, in: 30...35) {
                        VStack(alignment: .leading) {
                            Text("Laude Value:").font(.system(size: 15.0, weight: .semibold))
                            Text("\(laudeValue)").font(.system(size: 25.0, design: .rounded))
                        }
                    }
                }
                
                Section(header: Text("Other")) {
                    NavigationLink(destination: AboutView()) {
                        Label(title: { Text("About") }, icon: { Image(systemName: "info.circle.fill") })
                    }
                    NavigationLink(destination: ContributingView()) {
                        Label(title: { Text("Contribute") }, icon: { Image(systemName: "chevron.left.slash.chevron.right") })
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
            }
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
