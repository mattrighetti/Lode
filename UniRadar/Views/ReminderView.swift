//
//  ReminderView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct Reminder: Hashable {
    var daysLeft: Int
    var title: String
    var description: String
    var color: Color
}

struct ReminderView: View {
    
    var data = [
        Reminder(daysLeft: 34, title: "Spesa", description: "Descrizione della card", color: .yellow),
        Reminder(daysLeft: 334, title: "Cose a caso", description: "Descrizione della card più del testo a caso perché non ho idea di cosa scrivere di sensato", color: .flatDarkBlue),
        Reminder(daysLeft: 4, title: "Super Giant Card", description: "Questa carta avrà un sacco di testo ma ora a questo punto teoricamente dovrebbe scomparire", color: .flatDarkRed),
        Reminder(daysLeft: 124, title: "DSD", description: "Giorno del giudizio, consegna del prototipo funzionante", color: .flatLightRed)
    ]
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                // TODO
                // Check if better than List
                ForEach(self.data, id: \.self) { data in
                    RemiderCard(reminder: data)
                }
            }
                
        .navigationBarTitle("Statistics")
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(leading: Button(action: { print("Plus pressed") }) {
            Text("Edit")
                .font(.headline)
        }, trailing: Button(action: { print("Plus pressed") }) {
            Image(systemName: "plus")
                .font(.headline)
        })
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}
