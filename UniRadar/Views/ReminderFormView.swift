//
//  ReminderFormView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderFormView: View {

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var excludeLast: Bool = false
    
    @Binding var showReminderForm: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                Text("Name")
                    .font(.custom("Avenir Next Bold", size: 18.0))
                    .padding(.top)

                TextField("Insert reminder title", text: $name)
                    .modifier(RoundedGrayTextField())

                Text("Description")
                    .font(.custom("Avenir Next Bold", size: 18.0))
                    .padding(.top)

                TextField("Insert reminder description", text: $description)
                    .modifier(RoundedGrayTextField())

                Toggle(isOn: $excludeLast) {
                    Text("Exclude last day")
                        .font(.custom("Avenir Next Bold", size: 18.0))
                }.padding(.top)

                // TODO
                // Set a maximum date
                DatePicker(selection: self.$date, in: Date()..., displayedComponents: .date) {
                    Text("Select date")
                        .font(.custom("Avenir Next Bold", size: 18.0))
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showReminderForm.toggle()
                    }) {
                        
                        Text("Add")
                            .padding(.horizontal, 120)
                            .padding(.vertical)
                            .font(.custom("Avenir Next Regular", size: 24.0))
                            .foregroundColor(Color.white)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.flatLightRed, Color.flatDarkRed]),
                                               startPoint: UnitPoint(x: 0.5, y: 0.0),
                                               endPoint: UnitPoint(x: 0.5, y: 1.0))
                            )
                            .cornerRadius(18)
                        
                    }
                    
                    Spacer()
                }

                Spacer()

            }
            .padding()
            .navigationBarTitle(Text("New Reminder"))
        }
    }
}

struct ReminderFormView_Previews: PreviewProvider {
    
    @State static private var showForm: Bool = false
    
    static var previews: some View {
        ReminderFormView(showReminderForm: $showForm)
    }
}
