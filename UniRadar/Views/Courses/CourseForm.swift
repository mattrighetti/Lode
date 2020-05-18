//
//  ExamForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import CoreData

struct CourseForm: View {

    @Environment(\.presentationMode) var presentatitonMode
    @Environment(\.managedObjectContext) var managedObjectContext

    // Course Data
    @State private var title: String = ""
    @State private var difficulty: Int = 1
    @State private var courseMark: Int = 25
    @State private var expectedCourseMark: Int = 25
    @State private var courseCfu: Int = 5
    @State private var isPassed: Bool = false
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 0)
    @State private var iconIndex: GridIndex = GridIndex(row: 0, column: 0)
    
    // View Data
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    
    @State private var restoredCourse: Bool = false
    var course: Course?
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Group {
                    NavigationLink(
                        destination: IconColorPickerView(colorIndex: $colorIndex, glyphIndex: $iconIndex),
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

                                Image(systemName: Glyph.glyphArray[iconIndex.row][iconIndex.column])
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)

                            }
                            .padding(.top, 50)
                        }
                    )
                    
                    Header(title: "Title").padding(.top)
                    
                    TextField("Exam title", text: $title)
                        .padding()
                        .background(Color("cardBackground"))
                        .cornerRadius(8)
                    
                    HeaderCaption(title: "CFU", caption: "Ore totali: \(self.courseCfu * 25)").padding(.top)
                    
                    CustomStepper(value: $courseCfu, maxValue: 180, minValue: 1)
                    
                    Header(title: "Difficulty").padding(.top)
                    
                    Picker(selection: $difficulty, label: Text("")) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                
                }
                
                HeaderCaption(
                    title: "Mark expected",
                    caption: "This will be used for further statistics"
                ).padding(.top)
                
                CustomStepper(value: $expectedCourseMark, maxValue: 31, minValue: 18)
                
                Button(action: {
                    self.isPassed.toggle()
                }, label: {
                    HStack {
                        Text("Passed (singular)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        Image(systemName: self.isPassed ? "checkmark.seal" : "xmark.seal" )
                            .foregroundColor(self.isPassed ? Color.green : Color.red)
                    }
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                .padding(.top)
                
                VStack {
                    if self.isPassed {
                        HeaderCaption(
                            title: "Mark obtained",
                            caption: "The mark you got"
                        ).padding(.top)
                        
                        CustomStepper(value: $courseMark, maxValue: 31, minValue: 18)
                    } else {
                        EmptyView()
                    }
                }
                .padding(.bottom, 70)
                .transition(.scale)
                
            }
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .onAppear {
                if !self.restoredCourse {
                    if let courseToEdit = self.course {
                        self.title = courseToEdit.name!
                        self.difficulty = 3
                        self.courseMark = courseToEdit.mark != 0 ? Int(courseToEdit.mark) : 25
                        self.expectedCourseMark = Int(courseToEdit.expectedMark)
                        self.courseCfu = Int(courseToEdit.cfu)
                        self.isPassed = courseToEdit.mark != 0 ? true : false
                        self.colorIndex = GridIndex(row: Int(courseToEdit.colorRowIndex), column: Int(courseToEdit.colorColIndex))
                        // TODO how do you restore this?
                        self.iconIndex = GridIndex(row: 0, column: 0)
                    }
                    
                    self.restoredCourse.toggle()
                }
            }

            .navigationBarTitle("Add exam", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentatitonMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                        self.onDonePressed()
                        self.presentatitonMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func onDonePressed() {
        if self.course != nil {
            updateCourse()
        } else {
            addCourse()
        }
    }
    
    private func compile(course: Course) {
        course.id = UUID()
        course.name = title.isEmpty ? "No title" : title
        course.cfu = Int16(courseCfu)
        course.colorRowIndex = Int16(colorIndex.row)
        course.colorColIndex = Int16(colorIndex.column)
        course.iconName = Glyph.glyphArray[iconIndex.row][iconIndex.column]
        course.expectedMark = Int16(expectedCourseMark)
        
        if isPassed {
            course.mark = Int16(courseMark)
        } else {
            course.mark = 0
        }
    }
    
    private func updateCourse() {
        let fetchCourse: NSFetchRequest<Course> = Course.fetchRequest(withUUID: self.course!.id!)
        
        do {
            if let course = try managedObjectContext.fetch(fetchCourse).first {
                compile(course: course)
            }
            
            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }

    private func addCourse() {
        let newCourse = Course(context: managedObjectContext)
        compile(course: newCourse)
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    private func incrementMark() {
        if self.courseMark < 31 {
            self.courseMark += 1
        }
    }
    
    private func decrementMark() {
        if self.courseMark > 18 {
            self.courseMark -= 1
        }
    }
}

struct Header: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(NSLocalizedString(title, comment: ""))
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct HeaderCaption: View {
    
    var title: String
    var caption: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString(title, comment: "")).font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                Text(NSLocalizedString(caption, comment: ""))
                    .font(.caption)
            }
            Spacer()
        }
    }
}

struct CustomStepper: View {
    
    @Binding var value: Int
    var maxValue: Int
    var minValue: Int
    
    var body: some View {
        VStack {
            Stepper(onIncrement: {
                self.incrementValue()
            }, onDecrement: {
                self.decrementValue()
            }, label: {
                Text("\(value)")
                    .font(.title)
            })
            .padding()
            .background(Color("cardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    func incrementValue() {
        if value < maxValue {
            value += 1
        }
    }
    
    func decrementValue() {
        if value > minValue {
            value -= 1
        }
    }
}

struct ExamForm_Previews: PreviewProvider {
    @State private static var title: String = "title"

    static var previews: some View {
        CourseForm().colorScheme(.dark)
    }
}
