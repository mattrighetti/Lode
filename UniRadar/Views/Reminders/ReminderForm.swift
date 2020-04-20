//
//  ReminderForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderForm: View {
    
    @State var title: String = ""
    @State var description: String =  ""
    @State var selectedDate: Date = Date()
    // Does automatically the job to get the dismiss Bool of the View that launches this as sheet
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.top)
                Form {
                    Section(header: Text("Infos")) {
                        TextField("Reminder title", text: $title)
                        TextField("Reminder description", text: $title)
                    }
                    
                    Section(header: Text("Date")) {
                        DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .date) {
                            Text("Due date")
                        }
                    }
                }
            }
            .navigationBarTitle("Add reminder", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                print("Saving")
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            }))
        }
    }
}

struct ReminderForm_Previews: PreviewProvider {
    static var previews: some View {
        ReminderForm()
            .environment(\.colorScheme, .dark)
    }
}
