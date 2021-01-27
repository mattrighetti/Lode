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

    @StateObject private var viewModel = AssignmentViewViewModel()
    
    @State var showForm: Bool = false
    @State var addReminderPressed: Bool = false
    @State var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive
    @State private var assignmentToEdit: Assignment?

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(pickerSelection == 0 ? viewModel.dueAssignments : viewModel.pastAssignments, id: \.id) { assignment in
                        ReminderRow(assignment: assignment)
                            .onTapGesture {
                                self.assignmentToEdit = assignment
                                if editMode == .active {
                                    self.showForm.toggle()
                                }
                            }
                    }

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
                }.padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
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
        .onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        .sheet(
            isPresented: $showForm,
            onDismiss: {
                if editMode == .active {
                    self.editMode = .inactive
                    self.assignmentToEdit = nil
                }
            },
            content: {
                ReminderForm(assignment: editMode == .active ? assignmentToEdit : nil)
            }
        )
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
            .environment(\.colorScheme, .dark)
    }
}
