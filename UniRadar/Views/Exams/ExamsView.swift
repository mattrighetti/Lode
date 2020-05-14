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

    var body: some View {
        NavigationView {
            List {
                ForEach(examsFiltered(withTag: examPickerSelection), id: \.id) { exam in
                    ExamRow(exam: exam)
                        .listRowBackground(Color("background"))
                }.onDelete { IndexSet in
                    let deletedItem = self.viewModel.exams[IndexSet.first!]
                    self.managedObjectContext.delete(deletedItem)
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                }
                
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
                    .modifier(SegmentedButton())
                    .listRowBackground(Color("background"))
            }.alert(isPresented: self.$presentAlert) {
                Alert(
                    title: Text("No course is present"),
                    message: Text("You must first add a course before creating exams"),
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
                trailing: Button(action: { self.showModal() }, label: { Image(systemName: "plus.circle") })
            )
        }.sheet(isPresented: $addExamModalShown) {
            ExamForm(courses: self.viewModel.courses.map { $0.name! })
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
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
        if self.viewModel.courses.isEmpty {
            self.presentAlert.toggle()
        } else {
            self.addExamModalShown.toggle()
        }
    }
    
}

struct ExamRow: View {

    var exam: Exam
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.gradientsPalette[Int(exam.colorRowIndex)][Int(exam.colorColIndex)])
            }.frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(exam.title ?? "No name")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                Text("CFU: 5")
                Text("23 Jan 2020")
            }

            Spacer()
            
            ForEach(0..<3) { _ in 
                Image(systemName: "exclamationmark").padding(0)
            }
        }
        .modifier(CardStyle())
    }
}

struct ExamsView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        ExamsView(viewModel: ViewModel(context: context!))
            .environment(\.managedObjectContext, context!)
            .environment(\.colorScheme, .dark)
    }
}
