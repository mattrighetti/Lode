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
    @FetchRequest(entity: Exam.entity(), sortDescriptors: []) var exams: FetchedResults<Exam>

    @State private var addExamModalShown: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(exams, id: \.self) { exam in
                    ExamRow(exam: exam)
                        .listRowBackground(Color("background"))
                }.onDelete { IndexSet in
                    let deletedItem = self.exams[IndexSet.first!]
                    self.managedObjectContext.delete(deletedItem)
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                }
                
                Button(action: {
                        self.addExamModalShown.toggle()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: "plus.circle")
                                Spacer()
                                Text("Add exam").fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: 2,
                                    dash: [7]
                                )
                            )
                            .foregroundColor(.white)
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
            ExamForm(modalDismissed: self.$addExamModalShown)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct ExamRow: View {

    var exam: Exam
    
    var body: some View {
        ZStack {
            Color("cardBackground")
            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .flatLightRed]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: exam.iconName ?? "pencil").font(.system(size: 30))
                }.frame(width: 70, height: 70, alignment: .center)

                VStack(alignment: .leading) {
                    Text(exam.title ?? "No name")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom)

                    Text("Difficulty: \(exam.difficulty)").font(.caption)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("Fri").font(.system(size: 20, weight: .regular, design: .monospaced))
                    Text("24").font(.system(size: 20, weight: .regular, design: .monospaced))
                    Text("Dec").font(.system(size: 20, weight: .regular, design: .monospaced))
                }
            }
            .padding()
        }
        .background(Color("cardBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
    }
}

struct ExamsView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        .viewContext
    var exam = Exam(context: context)

    static var previews: some View {
        ExamsView().environment(\.colorScheme, .dark).environment(\.managedObjectContext, context)
    }
}
