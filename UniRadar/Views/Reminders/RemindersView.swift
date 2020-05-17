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
                ForEach(assignmentsFiltered(withTag: pickerSelection), id: \.id) { assignment in
                    ReminderRow(assignment: assignment)
                        .onTapGesture {
                            if self.editMode == .active {
                                self.assignmentToEdit = assignment
                                self.showForm.toggle()
                            }
                        }
                        .listRowBackground(Color("background"))
                }.onDelete { IndexSet in
                    let deletedItem = self.assignmentsFiltered(withTag: self.pickerSelection)[IndexSet.first!]
                    self.managedObjectContext.delete(deletedItem)
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                }
                
                Button(action: {
                    self.showForm.toggle()
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "plus.circle").foregroundColor(Color("bw"))
                            Spacer()
                            Text("Add reminder")
                                .fontWeight(.bold)
                                .foregroundColor(Color("bw"))
                        }
                        Spacer()
                    }
                })
                .modifier(SegmentedButton())
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
                    label: { Image(systemName: "plus.circle")
                })
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
}

struct ReminderRow: View {

    var assignment: Assignment

    var body: some View {
        ZStack {
            Color("cardBackground")
            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color.gradientsPalette[Int(assignment.colorRowIndex)][Int(assignment.colorColumnIndex)])

                    VStack {
                        Text("\(assignment.daysLeft)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        Text("missing")
                            .foregroundColor(.white)
                    }
                }.frame(width: 100, height: 80, alignment: .center)

                VStack(alignment: .leading) {
                    Text(assignment.title ?? "No title")
                        .font(.headline)
                        .fontWeight(.bold)
                        .layoutPriority(1)
                        .padding(.bottom, 5)

                    Text(assignment.caption ?? "No description")
                        .font(.caption)
                        .lineLimit(3)

                    isDueSoon()
                }

                Spacer()
            }
        }
        .modifier(CardStyle())
    }

    func isDueSoon() -> some View {
        if assignment.daysLeft < 5 {
            return AnyView(
                HStack {
                    Image(systemName: "exclamationmark.circle")
                    Text("Due soon")
                }
                .modifier(BadgePillStyle(color: .flatRed))
            )
        } else {
            return AnyView(
                EmptyView()
            )
        }
    }

}

struct RemindersView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        let assignment = Assignment(context: context!)
        assignment.title = "Start studying Artificial Intelligence"
        assignment.caption = "Start from the  bottom Start from the  bottom Start from the  bottom Start from the  bottom Start from the  bottom"
        assignment.dueDate = Date()
//        RemindersView(viewModel: ViewModel(context: context!))
//            .environment(\.colorScheme, .dark)
        return List {
            ReminderRow(assignment: assignment)
        }.colorScheme(.dark)
    }
}
