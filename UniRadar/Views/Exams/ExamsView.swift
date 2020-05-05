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

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.exams, id: \.id) { exam in
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
                        self.addExamModalShown.toggle()
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
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: 1,
                                    dash: [7]
                                )
                            )
                            .foregroundColor(Color("bw"))
                    ).listRowBackground(Color("background"))
            }

            .navigationBarTitle("Exams")
            .navigationBarItems(
                leading: EditButton(),
                center: AnyView(
                    Picker(selection: .constant(1), label: Text("Picker")) {
                        Text("Upcoming").tag(1)
                        Text("Past").tag(2)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                ),
                trailing: Button(action: { self.addExamModalShown.toggle() }, label: { Image(systemName: "plus.circle") })
            )
        }.sheet(isPresented: $addExamModalShown) {
            ExamForm()
                .environment(\.managedObjectContext, self.managedObjectContext)
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
        .padding()
        .background(Color("cardBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 25))
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
