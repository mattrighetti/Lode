//
//  AssignmentForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AssignmentForm: View {

    @Environment(\.presentationMode) var presentationMode

    var viewModel = AssignmentFormViewModel()

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var color: Color = Color.gradientsPalette[Int.random(in: 0...(Color.gradientsPalette.count - 1))]
    
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var editAssignmentMode: Bool = false
    var assignment: Assignment?

    var body: some View {
        NavigationView {
            List {
                ListView {
                    NavigationLinkButton(
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
                        }
                        .padding(.vertical, 5)
                    }
                }
                ListView(header: Text("General").fontWeight(.semibold)) {
                    VStack {
                        TextField("Assignment title", text: $title)
                            .card()
                        
                        TextField("Assignment description", text: $description)
                            .card()
                    }
                }
                ListView(header: Text("Date").fontWeight(.semibold)) {
                    DatePicker("Select date", selection: self.$date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle()).card()
                }
                if editAssignmentMode {
                    ListView {
                        Button(action: {
                            viewModel.delete(id: assignment!.id)
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
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .background(Color.background.ignoresSafeArea())
            .listStyle(InsetGroupedListStyle())
            .onAppear(perform: setupAssignment)
                
            .navigationBarTitle("Add assignment", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDonePressed()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Some fields are not compiled"),
                message: Text("You have at least to provide a title"),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }
    
    private func onDonePressed() {
        guard !title.isEmpty else {
            showAlert.toggle()
            return
        }
        if editAssignmentMode {
            viewModel.update(withId: assignment!.id, title: title, caption: description, color: color.toHex!, dueDate: date)
        } else {
            viewModel.addAssignment(title: title, caption: description, color: color.toHex!, dueDate: date)
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func setupAssignment() {
        if let assignmentToEdit = assignment {
            self.title = assignmentToEdit.title
            self.description = assignmentToEdit.caption
            self.date = assignmentToEdit.dueDate
            self.color = Color(hex: assignmentToEdit.color)!

            self.editAssignmentMode.toggle()
        }
    }
}

struct AssignmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentForm()
            .environment(\.colorScheme, .dark)
    }
}
