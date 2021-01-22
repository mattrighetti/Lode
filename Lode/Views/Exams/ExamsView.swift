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
    
    @FetchRequest(entity: Exam.entity(), sortDescriptors: [], animation: .spring())
    private var exams: FetchedResults<Exam>

    @FetchRequest(entity: Course.entity(), sortDescriptors: [], animation: .spring())
    private var courses: FetchedResults<Course>

    @State private var addExamModalShown: Bool = false
    @State private var examPickerSelection: Int = 0
    @State private var presentAlert: Bool = false
    @State private var editMode = EditMode.inactive
    @State private var examToEdit: Exam?

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(examsFiltered(withTag: examPickerSelection).sorted(by: { $0.date! < $1.date! }), id: \.id) { exam in
                        ExamRow(exam: exam)
                            .onTapGesture {
                                self.examToEdit = exam
                                if editMode == .active {
                                    self.addExamModalShown.toggle()
                                }
                            }
                            .onLongPressGesture { print("Long pressure of element \(exam)") }
                    }.onDelete(perform: deleteExam)

                    Button(action: {
                        showModal()
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
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
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
                    action: { showModal() },
                    label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                )
            )
            
            .environment(\.editMode, $editMode)
        }.onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        .sheet(
            isPresented: $addExamModalShown,
            onDismiss: {
                if editMode == .active {
                    self.editMode = .inactive
                    self.examToEdit = nil
                }
            },
            content: {
                ExamForm(
                    courses: courses.compactMap{ course in course }.filter({ $0.mark == 0 }).map { $0.name! },
                    exam: editMode == .active ? examToEdit : nil
                )
                .environment(\.managedObjectContext, managedObjectContext)
        })
    }
    
    func examsFiltered(withTag tag: Int) -> [Exam] {
        let upcomingFilter: (Exam) -> Bool = { $0.date! > Date() }
        let pastFilter: (Exam) -> Bool = { $0.date! <= Date() }
        
        switch tag {
        case 0:
            return exams.filter(upcomingFilter)
        case 1:
            return exams.filter(pastFilter)
        default:
            return exams.compactMap { exam in exam }
        }
    }
    
    private func showModal() {
        if courses.compactMap({ course in course }).filter({ $0.mark == 0 }).map({ $0.name! }).isEmpty {
            self.presentAlert.toggle()
        } else {
            self.addExamModalShown.toggle()
        }
    }
    
    private func deleteExam(at offsets: IndexSet) {
        let deletedItem = examsFiltered(withTag: examPickerSelection).sorted(by: { $0.date! < $1.date! })[offsets.first!]
        managedObjectContext.delete(deletedItem)
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
}

struct ExamsView_Previews: PreviewProvider {
    static var previews: some View {
        ExamsView()
    }
}
