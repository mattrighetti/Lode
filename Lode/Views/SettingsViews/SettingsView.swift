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
                            Text("Total CFU").font(.system(size: 15.0, weight: .regular))
                            Text("\(totalCfu)").font(.system(size: 25.0, design: .rounded))
                        }
                    }.padding(.vertical, 7)
                    Stepper(value: laudeValueProxy, in: 30...35) {
                        VStack(alignment: .leading) {
                            Text("Laude value").font(.system(size: 15.0, weight: .regular))
                            Text("\(laudeValue)").font(.system(size: 25.0, design: .rounded))
                        }
                    }.padding(.vertical, 7)
                }
                
                Section(header: Text("Other")) {
//                    NavigationLink(destination: TipJarView()) {
//                        Label(title: { Text("Tip Jar") }, icon: {
//                            CircledIcon(color: .red) {
//                                Image(systemName: "app.gift")
//                                    .font(.title3)
//                            }
//                        })
//                    }.padding(.vertical, 10)
                    NavigationLink(destination: AboutView()) {
                        Label(title: { Text("About") }, icon: {
                            CircledIcon(color: .blue) {
                                Image(systemName: "at")
                                    .font(.title3)
                            }
                        })
                    }.padding(.vertical, 10)
                    NavigationLink(destination: ContributingView()) {
                        Label(title: { Text("Contribute") }, icon: {
                            CircledIcon(color: .yellow) {
                                Image(systemName: "person.2.circle")
                                    .font(.title3)
                            }
                        })
                    }.padding(.vertical, 10)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
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
