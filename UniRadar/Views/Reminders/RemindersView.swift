//
//  RemindersView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import CoreData
import SwiftUI

struct RemindersView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var viewModel: ViewModel
    
    @State var showForm: Bool = false
    @State var addReminderPressed: Bool = false
    @State var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive
    @State private var assignmentToEdit: Assignment?

    var body: some View {
        NavigationView {
            List {
                ForEach(assignmentsFiltered(withTag: pickerSelection).sorted(by: { $0.dueDate! < $1.dueDate! }), id: \.id) { assignment in
                    Group {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            ReminderRow(assignment: assignment)
                                .onTapGesture {
                                    self.assignmentToEdit = assignment
                                    if self.editMode == .active {
                                        self.showForm.toggle()
                                    }
                                }
                                .listRowBackground(Color("background"))
                        } else {
                            ZStack {
                                NavigationLink(destination: ReminderDescriptionPage(assignment: self.assignmentToEdit), isActive: .constant(true)) {
                                    EmptyView()
                                }.listRowBackground(Color.background)
                                
                                ReminderRow(assignment: assignment)
                                    .onTapGesture {
                                        self.assignmentToEdit = assignment
                                        if self.editMode == .active {
                                            self.showForm.toggle()
                                        }
                                    }
                            }
                        }
                    }
                }.onDelete(perform: self.deleteAssignment)
                
                Button(action: {
                    self.showForm.toggle()
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "plus.circle").foregroundColor(Color("bw"))
                            Spacer()
                            Text("Add assignment")
                                .fontWeight(.bold)
                                .foregroundColor(Color("bw"))
                        }
                        Spacer()
                    }
                })
                .segmentedButton()
                .listRowBackground(Color("background"))
            }

            .navigationBarTitle("Assignments")
            .navigationBarItems(
                leading: EditButton(),
                center: AnyView(
                    Picker(selection: $pickerSelection, label: Text("Picker")) {
                        Text("Current").tag(0)
                        Text("Past").tag(1)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                ),
                trailing: Button(
                    action: { self.showForm.toggle() },
                    label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                )
            )
            
            .environment(\.editMode, $editMode)
        }
        .sheet(
            isPresented: $showForm,
            onDismiss: {
                if self.editMode == .active {
                    self.editMode = .inactive
                    self.assignmentToEdit = nil
                }
            },
            content: {
                ReminderForm(assignment: self.editMode == .active ? self.assignmentToEdit : nil)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        )
    }
    
    private func assignmentsFiltered(withTag tag: Int) -> [Assignment] {
        let upcomingFilter: (Assignment) -> Bool = { $0.dueDate! > Date() }
        let pastFilter: (Assignment) -> Bool = { $0.dueDate! <= Date() }
        
        switch tag {
        case 0:
            return viewModel.assignments.filter(upcomingFilter)
        case 1:
            return viewModel.assignments.filter(pastFilter)
        default:
            return viewModel.assignments
        }
    }
    
    private func deleteAssignment(at offsets: IndexSet) {
        let deletedItem = self.assignmentsFiltered(withTag: self.pickerSelection).sorted(by: { $0.dueDate! < $1.dueDate! })[offsets.first!]
        self.managedObjectContext.delete(deletedItem)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
}

struct RemindersView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        RemindersView(viewModel: ViewModel(context: context!))
            .environment(\.colorScheme, .dark)
    }
}
