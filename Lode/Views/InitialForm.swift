//
//  InitialForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 17/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct InitialForm: View {
    
    @Environment(\.presentationMode) var presentationMode

    @AppStorage("totalCfu") var totalCfu: Int = 120
    @AppStorage("laudeValue") var laudeValue: Int = 30
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total CFUs of your study plan")) {
                    Stepper(value: self.$totalCfu, in: 30...1000) {
                        Text("\(totalCfu)")
                            .font(.title)
                    }
                    .padding(.vertical, 7)
                }
                .listRowBackground(Color.cardBackground)
                Section(header: Text("Total CFUs of your study plan")) {
                    Stepper(value: self.$laudeValue, in: 30...35) {
                        Text("\(laudeValue)")
                            .font(.title)
                    }
                    .padding(.vertical, 7)
                }
                .listRowBackground(Color.cardBackground)
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color("background"))
            .onAppear {
                UIScrollView.appearance().backgroundColor = UIColor(named: "background")
                UITableView.appearance().backgroundColor = UIColor(named: "background")
                UITableView.appearance().separatorStyle = .none
            }
            
            .navigationBarTitle("Initial setup", displayMode: .large)
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

struct InitialForm_Previews: PreviewProvider {
    static var previews: some View {
        InitialForm()
            .colorScheme(.dark)
            .environment(\.locale, .init(identifier: "it"))
    }
}
