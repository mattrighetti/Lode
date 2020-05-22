//
//  ReminderForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderForm: View {
    
    // Does automatically the job to get the dismiss Bool of the View that launches this as sheet
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 3)
    
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    
    @State private var restoredAssignment: Bool = false
    var assignment: Assignment?

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: ColorPickerView(colorIndex: $colorIndex),
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
                        
                    }.padding(.top, 50)
                }
                
                HStack {
                    Text("Info").font(.headline).fontWeight(.bold)
                    Spacer()
                }
                .padding(.top)
                
                TextField("Assignment title", text: $title)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                TextField("Assignment description", text: $description)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Header(title: "Date").padding(.top)
                
                Button(action: {
                    withAnimation {
                        self.isShowingDatePicker.toggle()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text(date.textDateRappresentation)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                .padding(.top)

                HStack {
                    Spacer()
                    if self.isShowingDatePicker {
                        DatePicker(selection: self.$date, in: Date()..., displayedComponents: .date) {
                            EmptyView()
                        }.labelsHidden()
                    }
                    Spacer()
                }
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .transition(.scale)
                .padding(.bottom, 50)
                
            }
            .scrollViewWithoutBackground()
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .onAppear {
                self.restoreAssignment()
            }
                
            .navigationBarTitle("Add assignment", displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Cancel")
                    }
                ),
                trailing: Button(
                    action: {
                        self.onDonePressed()
                    },
                    label: {
                        Text("Done")
                    }
                )
            )
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func onDonePressed() {
        if self.assignment != nil {
            updateAssignment()
        } else {
            addAssignment()
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func compile(assignment: Assignment) {
        assignment.id = UUID()
        assignment.title = title.isEmpty ? "No title" : title
        assignment.caption = description
        assignment.colorColumnIndex = Int16(colorIndex.column)
        assignment.colorRowIndex = Int16(colorIndex.row)
        assignment.dueDate = date
    }
    
    private func updateAssignment() {
        let fetchAssignment = Assignment.fetchRequest(withUUID: self.assignment!.id!)
        
        do {
            if let course = try managedObjectContext.fetch(fetchAssignment).first {
                compile(assignment: course)
            }
            
            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
    
    private func addAssignment() {
        let newAssignment = Assignment(context: managedObjectContext)
        compile(assignment: newAssignment)
        
        saveContext()
    }
    
    private func restoreAssignment() {
        if !self.restoredAssignment {
            if let assignmentToEdit = self.assignment {
                self.title = assignmentToEdit.title ?? ""
                self.description = assignmentToEdit.caption ?? ""
                self.date = assignmentToEdit.dueDate!
                self.colorIndex = GridIndex(row: Int(assignmentToEdit.colorRowIndex), column: Int(assignmentToEdit.colorColumnIndex))
            }
            
            self.restoredAssignment.toggle()
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
}

struct ReminderForm_Previews: PreviewProvider {
    static var previews: some View {
        ReminderForm()
            .environment(\.colorScheme, .dark)
    }
}
