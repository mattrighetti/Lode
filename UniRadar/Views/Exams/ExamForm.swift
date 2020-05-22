//
//  CourseForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var courses: [String]
    
    @State private var name: String = ""
    @State private var course: String = ""
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var date: Date = Date()
    
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var showCourses: Bool = false
    @State private var courseIndex: Int = -1
    @State private var bottomPadding: CGFloat = 0
    
    @State private var restoredExam: Bool = false
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
                    destination: StringList(strings: courses, selectedIndex: $courseIndex),
                    isActive: $showCourses,
                    label: {
                        HStack {
                            Text(courseIndex != -1 ? courses[courseIndex] : NSLocalizedString("Select a course", comment: ""))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .card()
                    }
                )
                
                Header(title: "Date").padding(.top)
                
                Button(action: {
                    withAnimation {
                        self.isShowingDatePicker.toggle()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text(date.textDateRappresentation)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .card()
                })
                .padding(.top)

                HStack {
                    Spacer()
                    if self.isShowingDatePicker {
                        DatePicker(selection: self.$date, displayedComponents: .date) {
                            EmptyView()
                        }.labelsHidden()
                    }
                    Spacer()
                }
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .transition(.scale)
                .padding(.bottom, 50)
                
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
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    self.onDonePressed()
                }
            )
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    private func onDonePressed() {
        if self.fieldsAreCompiled() {
            if self.exam != nil {
                self.updateExam()
            } else {
                self.addExam()
            }
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.showAlert.toggle()
        }
    }
    
    private func fieldsAreCompiled() -> Bool {
        if self.courseIndex == -1 || self.name.isEmpty {
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
        let fetchExam = Exam.fetchRequest(withUUID: self.exam!.id!)
        
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
        ExamForm(courses: ["This", "Other", "One"], exam: nil).colorScheme(.dark).accentColor(.darkRed)
    }
}
