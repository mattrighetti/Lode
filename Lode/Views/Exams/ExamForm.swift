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

    @StateObject var viewModel = ExamFormViewModel()
    
    @State private var name: String = ""
    @State private var course: Course? = nil
    @State private var color: Color = Color.gradientsPalette[Int.random(in: 0...(Color.gradientsPalette.count - 1))]
    @State private var date: Date = Date()
    
    @State private var isShowingDatePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var courseIndex: Int = -1
    @State private var editExamMode: Bool = false
    @State private var showCourseSelection: Bool = false
    @State private var showColorPickerView: Bool = false

    var exam: Exam?
    
    var body: some View {
        NavigationView {
            List {
                ListView {
                    NavigationLinkButton(
                        destination: ColorPickerView(selectedColor: $color),
                        isActive: $showColorPickerView
                    ) {
                        ZStack {
                            Circle()
                            .stroke()
                                .fill(Color.blue)
                                .frame(width: 105, height: 105, alignment: .center)

                            Circle()
                                .fill(color)
                                .frame(width: 100, height: 100, alignment: .center)
                        }
                        .padding(.vertical, 5)
                    }
                }
                ListView(header: Text("Description").fontWeight(.semibold)) {
                    TextField("Exam description", text: $name)
                        .padding()
                        .background(Color("cardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                ListView(header: Text("Course").fontWeight(.semibold)) {
                    NavigationLinkButton(
                        destination: StringList(courses: viewModel.courseNotPassed, selectedIndex: $courseIndex),
                        isActive: $showCourseSelection
                    ) {
                        HStack {
                            Text(courseIndex != -1 ? viewModel.courseNotPassed[courseIndex].name : NSLocalizedString("Select a course", comment: ""))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.card()
                    }
                }
                ListView(header: Text("Date").fontWeight(.semibold)) {
                    DatePicker("Select date", selection: self.$date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .card()
                }
                if editExamMode {
                    ListView {
                        Button(action: {
                            viewModel.deleteExam(withId: exam!.id)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Delete")
                                    .padding()
                                Spacer()
                            }
                            .background(Color.flatRed)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.background.ignoresSafeArea())
            .onAppear(perform: setupExam)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Some fields are not compiled"),
                    message: Text("You have to compile every field to create a course"),
                    dismissButton: .cancel(Text("Ok"))
                )
            }

            .navigationBarTitle("Add exam", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDonePressed()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func setupExam() {
        if let exam = exam {
            name = exam.title
            date = exam.date
            color = Color(hex: exam.color)!
            guard let index = viewModel.courseNotPassed.firstIndex(of: exam.courseId) else {
                fatalError("Course error is not present in the notPassedCourse")
            }
            courseIndex = index
            editExamMode = true
        }
    }
    
    private func onDonePressed() {
        if fieldsAreCompiled() {
            if exam != nil {
                viewModel.update(withId: exam!.id, name: name, color: color.toHex!, date: date, course: viewModel.courseNotPassed[courseIndex])
            } else {
                viewModel.addExam(name: name, color: color.toHex!, date: date, course: viewModel.courseNotPassed[courseIndex])
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
}

struct CourseForm_Previews: PreviewProvider {
    @State private var index: Int = -1
    static var previews: some View {
        ExamForm().colorScheme(.dark).accentColor(.darkRed)
    }
}
