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
    
    @State private var showReminderForm = false
    
    var data = [
        Reminder(daysLeft: 34, title: "Spesa", description: "Descrizione della card", color: .yellow),
        Reminder(daysLeft: 334, title: "Cose a caso", description: "Descrizione della card più del testo a caso perché non ho idea di cosa scrivere di sensato", color: .blue),
        Reminder(daysLeft: 4, title: "Super Giant Card with line limit", description: "Questa carta avrà un sacco di testo ma ora a questo punto teoricamente dovrebbe scomparire", color: .green),
        Reminder(daysLeft: 124, title: "DSD", description: "Giorno del giudizio, consegna del prototipo funzionante", color: .red)
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
                
        .navigationBarTitle("Reminders")
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(leading: Button(action: { print("Plus pressed") }) {
                Text("Edit")
                    .font(.headline)
            }, trailing: Button(action: { self.showReminderForm.toggle() }) {
                Image(systemName: "plus")
                    .font(.headline)
                }
        )}.sheet(isPresented: $showReminderForm) {
            ReminderFormView()
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}
