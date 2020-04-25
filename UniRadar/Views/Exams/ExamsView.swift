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
    @FetchRequest(entity:Exam.entity(),sortDescriptors:[]) var exams: FetchedResults<Exam>

    @State private var addExamModalShown: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(exams, id: \.self) { exam in
                    ExamRow(exam: exam)
                        .listRowBackground(Color("background"))
                }.onDelete { _ in
                    print("Deleted")
                }
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
                trailing: Button(action: { self.addExamModalShown.toggle() }, label: { Image(systemName: "plus") })
            )
        }.sheet(isPresented: $addExamModalShown) {
            ExamForm(modalDismissed: self.$addExamModalShown)
        }
    }

    // MARK: - Methods

    func addExam() {
        let exam = Exam(context: managedObjectContext)
        exam.examId = UUID()
        exam.title = "Title"
        exam.difficulty = 3

        do {
            try self.managedObjectContext.save()
        } catch {
            print("Could not save file")
        }
    }

}

// TODO do not force unwrap values
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
        .clipShape(RoundedRectangle(cornerRadius: 25))
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
