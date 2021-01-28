//
//  ReminderForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderForm: View {

    @Environment(\.presentationMode) var presentationMode

    var viewModel = AssignmentFormViewModel()

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var color: Color = Color.gradientsPalette[Int.random(in: 0...Color.gradientsPalette.count)]
    
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    
    @State private var editAssignmentMode: Bool = false
    var assignment: Assignment?

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                NavigationLink(
                    destination: ColorPickerView(selectedColor: $color),
                    isActive: $activeColorNavigationLink
                ) {
                    ZStack {
                        Circle()
                            .stroke()
                            .fill(Color.blue)
                            .frame(width: 105, height: 105, alignment: .center)

                        Circle()
                            .fill(color)
                            .frame(width: 100, height: 100, alignment: .center)
                        
                    }.padding(.top, 50)
                }
                
                HStack {
                    Text("Info").font(.headline).fontWeight(.bold)
                    Spacer()
                }
                .padding(.top)
                
                TextField("Assignment title", text: $title)
                    .card()
                
                TextField("Assignment description", text: $description)
                    .card()
                
                Header(title: "Date").padding(.top)

                DatePicker("Select date", selection: self.$date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())

                if editAssignmentMode {
                    Button(action: {
                        viewModel.delete(id: assignment!.id!)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Delete")
                                .padding()
                            Spacer()
                        }
                        .background(Color.flatRed)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                    })
                }
                
            }
            .scrollViewWithoutBackground()
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .onAppear(perform: setupAssignment)
                
            .navigationBarTitle("Add assignment", displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Cancel")
                    }
                ),
                trailing: Button(
                    action: {
                        onDonePressed()
                    },
                    label: {
                        Text("Done")
                    }
                )
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func onDonePressed() {
        if editAssignmentMode {
            viewModel.update(withId: assignment!.id!, title: title, caption: description, color: color.toHex!, dueDate: date)
        } else {
            viewModel.addAssignment(title: title, caption: description, color: color.toHex!, dueDate: date)
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func setupAssignment() {
        if let assignmentToEdit = assignment {
            self.title = assignmentToEdit.title!
            self.description = assignmentToEdit.caption!
            self.date = assignmentToEdit.dueDate!
            self.color = Color(hex: assignmentToEdit.color!)!

            self.editAssignmentMode.toggle()
        }
    }
    
}

struct ReminderForm_Previews: PreviewProvider {
    static var previews: some View {
        ReminderForm()
            .environment(\.colorScheme, .dark)
    }
}
