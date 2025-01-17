//
//  AssignmentsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import CoreData
import SwiftUI
import os

fileprivate let logger = Logger(subsystem: "com.mattrighetti.Lode", category: "ReminderView")

struct AssignmentsView: View {

    @ObservedObject private var sheet = SheetState()
    @StateObject private var viewModel = AssignmentViewViewModel()

    @State private var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive

    private var columnsLayout: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        } else {
            return [GridItem(.flexible())]
        }
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columnsLayout) {
                    ForEach(pickerSelection == 0 ? viewModel.dueAssignments : viewModel.pastAssignments, id: \.id) { assignment in
                        AssignmentRow(assignment: assignment)
                            .onTapGesture {
                                if editMode == .active {
                                    logger.log("Setting assignment to edit")
                                    sheet.assignmentToEdit = assignment
                                }
                            }
                            .onLongPressGesture {
                                generateHapticFeedback()
                                logger.log("LongPress -> Setting assignment to edit")
                                sheet.assignmentToEdit = assignment
                            }
                    }

                    Button(action: {
                        sheet.isShowing.toggle()
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
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
            }
            .background(Color.background.ignoresSafeArea())

            .navigationBarTitle("Assignments")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Picker(selection: $pickerSelection, label: Text("Picker")) {
                            Text("Current").tag(0)
                            Text("Past").tag(1)
                        }
                        .foregroundColor(Color.blue)
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        Button(
                            action: { sheet.isShowing.toggle() },
                            label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                        )
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        .sheet(
            isPresented: $sheet.isShowing,
            onDismiss: {
                sheet.assignmentToEdit = nil
                editMode = .inactive
            },
            content: {
                AssignmentForm(assignment: sheet.assignmentToEdit)
            }
        )
    }
    
    private func generateHapticFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

fileprivate class SheetState: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var assignmentToEdit: Assignment? = nil {
        didSet {
            isShowing = assignmentToEdit != nil
        }
    }
}

struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
            .environment(\.colorScheme, .dark)
    }
}
