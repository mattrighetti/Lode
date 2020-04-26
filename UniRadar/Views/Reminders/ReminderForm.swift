//
//  ReminderForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderForm: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 3)
    @State private var iconName: String = ""
    @State private var activeColorNavigationLink: Bool = false
    // Does automatically the job to get the dismiss Bool of the View that launches this as sheet
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: GradientPickerView(gradientIndex: $colorIndex, iconName: $iconName),
                    isActive: $activeColorNavigationLink
                ) {
                    ZStack {
                        Circle()
                            .stroke()
                            .fill(Color.blue)
                            .frame(width: 105, height: 105, alignment: .center)

                        Circle()
                            .fill(Color.gradientsPalette[colorIndex.row][colorIndex.column])
                            .frame(width: 100, height: 100, alignment: .center)

                        Image(systemName: iconName)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                    }.padding(.top, 50)
                }
                
                Form {
                    Section(header: Text("Infos")) {
                        TextField("Assignment title", text: $title)
                        TextField("Assignment description", text: $title)
                    }

                    Section(header: Text("Date")) {
                        DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .date) {
                            Text("Due date")
                        }
                    }
                }
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Add reminder", displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Cancel")
                    }),
                trailing: Button(
                    action: {
                        print("Saving")
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
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
