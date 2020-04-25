//
//  ReminderForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderForm: View {
    
    @State private var title: String = ""
    @State private var description: String =  ""
    @State private var selectedDate: Date = Date()
    @State private var gradientIndex: Int = 0
    // Does automatically the job to get the dismiss Bool of the View that launches this as sheet
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.top)
                Form {
                    Section(header: Text("Infos")) {
                        TextField("Assignment title", text: $title)
                        TextField("Assignment description", text: $title)
                    }
                    
                    Section(header: Text("Color")) {
                        HStack {
                            Text("Color")
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 35, height: 35)
                                .padding(.horizontal)
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical, 5)
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
