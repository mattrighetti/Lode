//
//  ExamsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 21/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import CoreData
import SwiftUI

struct ExamsView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var viewModel: ViewModel

    @State private var addExamModalShown: Bool = false
    @State private var examPickerSelection: Int = 0
    @State private var presentAlert: Bool = false
    @State private var editMode = EditMode.inactive
    @State private var examToEdit: Exam?

    var body: some View {
        NavigationView {
            List {
                ForEach(examsFiltered(withTag: examPickerSelection).sorted(by: { $0.date! < $1.date! }), id: \.id) { exam in
                    Group {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            ExamRow(exam: exam)
                                .onTapGesture {
                                    self.examToEdit = exam
                                    if self.editMode == .active {
                                        self.addExamModalShown.toggle()
                                    }
                                }
                                .listRowBackground(Color("background"))
                        } else {
                            ZStack {
                                NavigationLink(destination: ExamDescriptionPage(exam: self.examToEdit), isActive: .constant(true)) {
                                    EmptyView()
                                }.listRowBackground(Color("background"))
                                
                                ExamRow(exam: exam)
                                    .onTapGesture {
                                        self.examToEdit = exam
                                        if self.editMode == .active {
                                            self.addExamModalShown.toggle()
                                        }
                                    }
                            }
                        }
                    }
                }.onDelete(perform: self.deleteExam)
                
                Button(action: {
                    self.showModal()
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "plus.circle").foregroundColor(Color("bw"))
                            Spacer()
                            Text("Add exam")
                                .fontWeight(.bold)
                                .foregroundColor(Color("bw"))
                        }
                        Spacer()
                    }
                })
                .segmentedButton()
                .listRowBackground(Color("background"))
            }
            .alert(isPresented: self.$presentAlert) {
                Alert(
                    title: Text("No active course is present"),
                    message: Text("You must first add an active course to be able to add exams"),
                    dismissButton: .cancel(Text("Ok"))
                )
            }

            .navigationBarTitle("Exams")
            .navigationBarItems(
                leading: EditButton(),
                center: AnyView(
                    Picker(selection: $examPickerSelection, label: Text("Picker")) {
                        Text("Upcoming").tag(0)
                        Text("Past").tag(1)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                ),
                trailing: Button(
                    action: { self.showModal() },
                    label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                )
            )
            
            .environment(\.editMode, $editMode)
        }.padding(1)
        .sheet(
            isPresented: $addExamModalShown,
            onDismiss: {
                if self.editMode == .active {
                    self.editMode = .inactive
                    self.examToEdit = nil
                }
            },
            content: {
                ExamForm(
                    courses: self.viewModel.courses.filter { $0.mark == 0 }.map { $0.name! },
                    exam: self.editMode == .active ? self.examToEdit : nil
                )
                .environment(\.managedObjectContext, self.managedObjectContext)
        })
    }
    
    func examsFiltered(withTag tag: Int) -> [Exam] {
        let upcomingFilter: (Exam) -> Bool = { $0.date! > Date() }
        let pastFilter: (Exam) -> Bool = { $0.date! <= Date() }
        
        switch tag {
        case 0:
            return viewModel.exams.filter(upcomingFilter)
        case 1:
            return viewModel.exams.filter(pastFilter)
        default:
            return viewModel.exams
        }
    }
    
    private func showModal() {
        if self.viewModel.courses.filter({ $0.mark == 0 }).map({ $0.name! }).isEmpty {
            self.presentAlert.toggle()
        } else {
            self.addExamModalShown.toggle()
        }
    }
    
    private func deleteExam(at offsets: IndexSet) {
        let deletedItem = self.examsFiltered(withTag: self.examPickerSelection).sorted(by: { $0.date! < $1.date! })[offsets.first!]
        self.managedObjectContext.delete(deletedItem)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
}

struct ExamsView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        ExamsView(viewModel: ViewModel(context: context!))
    }
}
