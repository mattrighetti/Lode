//
//  CourseForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import Combine

struct ExamForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var viewModel: ExamViewViewModel
    
    @State private var name: String = ""
    @State private var course: String = ""
    @State private var colorIndex: GridIndex = GridIndex(row: Int.random(in: 0...2), column: Int.random(in: 0...4))
    @State private var date: Date = Date()
    
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var showCourses: Bool = false
    @State private var courseIndex: Int = -1
    @State private var bottomPadding: CGFloat = 0
    
    @State private var restoredExam: Bool = false
    @State var courses: [String] = []

    var exam: Exam?
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                NavigationLink(
                    destination: ColorPickerView(colorIndex: $colorIndex),
                    isActive: $activeColorNavigationLink,
                    label: {
                        ZStack {
                            Circle()
                            .stroke()
                                .fill(Color.blue)
                                .frame(width: 105, height: 105, alignment: .center)

                            Circle()
                                .fill(Color.gradientsPalette[colorIndex.row][colorIndex.column])
                                .frame(width: 100, height: 100, alignment: .center)

                        }
                        .padding(.top, 50)
                    }
                )
                
                Header(title: "Description").padding(.top)
                
                TextField("Exam description", text: $name)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Header(title: "Course")
                    .padding(.top)
                
                NavigationLink(
                    destination: StringList(strings: viewModel.courseNotPassedStrings, selectedIndex: $courseIndex),
                    isActive: $showCourses,
                    label: {
                        HStack {
                            Text(courseIndex != -1 ? viewModel.courseNotPassedStrings[courseIndex] : NSLocalizedString("Select a course", comment: ""))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .card()
                    }
                )

                Header(title: "Date").padding(.top)

                DatePicker("Select date", selection: self.$date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
            }
            .scrollViewWithoutBackground()
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Some fields are not compiled"),
                    message: Text("You have to compile every field to create a course"),
                    dismissButton: .cancel(Text("Ok"))
                )
            }

            .navigationBarTitle("Add exam", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    onDonePressed()
                }
            )
        }
    }
    
    private func onDonePressed() {
        if fieldsAreCompiled() {
            if exam != nil {
                updateExam()
            } else {
                addExam()
            }
            presentationMode.wrappedValue.dismiss()
        } else {
            self.showAlert.toggle()
        }
    }
    
    private func fieldsAreCompiled() -> Bool {
        if courseIndex == -1 || name.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func compile(exam: Exam) {
        exam.id = UUID()
        exam.title = name.isEmpty ? NSLocalizedString("No name", comment: "") : name
        exam.date = date
        exam.colorColIndex = Int16(colorIndex.column)
        exam.colorRowIndex = Int16(colorIndex.row)
    }
    
    private func updateExam() {
        let fetchExam = Exam.fetchRequest(withUUID: exam!.id!)
        
        do {
            if let exam = try managedObjectContext.fetch(fetchExam).first {
                compile(exam: exam)
            }
            
            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
    
    private func addExam() {
        let newExam = Exam(context: managedObjectContext)
        compile(exam: newExam)
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct CourseForm_Previews: PreviewProvider {
    @State private var index: Int = -1
    static var previews: some View {
        ExamForm(viewModel: ExamViewViewModel()).colorScheme(.dark).accentColor(.darkRed)
    }
}
