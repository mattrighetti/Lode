//
//  ExamForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.mattrighetti.Lode", category: "CourseForm")

struct CourseForm: View {

    @Environment(\.presentationMode) var presentationMode

    var viewModel = CourseFormViewModel()

    // Course Data
    @State private var title: String = ""
    @State private var courseMark: Int = 25
    @State private var expectedCourseMark: Int = 25
    @State private var courseCfu: Int = 5
    @State private var isPassed: Bool = false
    @State private var color: Color = Color.gradientsPalette[Int.random(in: 0...(Color.gradientsPalette.count - 1))]
    @State private var glyph: String = Glyph.glyphArray[Int.random(in: 0...(Glyph.glyphArray.count - 1))]
    
    // View Data
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var editCourseMode: Bool = false

    var course: Course?
    
    private var acronym: String? {
        let toRemove = ["and", "e", "of", "di"]
        if title.count > 25 {
            let splitString = title
                .split { $0 == " " }
                .map { String($0) }
                .filter { !toRemove.contains($0) }
            
            return splitString.map({ String($0.first!).uppercased() }).reduce("", +)
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            List {
                ListView {
                    NavigationLinkButton(
                        destination: IconColorPickerView(selectedColor: $color, selectedGlyph: $glyph),
                        isActive: $activeColorNavigationLink
                    ) {
                        ZStack {
                            Circle()
                                .stroke()
                                .fill(Color.blue)
                                .frame(width: 105, height: 105, alignment: .center)

                            Circle()
                                .fill(color)
                                .frame(width: 100, height: 100, alignment: .center)

                            Image(systemName: glyph)
                                .font(.system(size: 50))
                                .foregroundColor(.white)

                        }
                        .padding(.vertical, 5)
                    }
                }
                ListView {
                    VStack {
                        if acronym != nil {
                            HStack {
                                Text("Title will be truncated to:")
                                Text(acronym ?? "")
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                            .transition(.move(edge: .bottom))
                        }
                        
                        TextField("Course title", text: $title)
                            .card()
                    }
                }
                ListView(header: Text("Course CFU").fontWeight(.semibold)) {
                    Stepper(value: $courseCfu, in: 1...50, label: {
                        Text("\(courseCfu)").font(.title)
                    })
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                ListView(header: Text("Expected mark").fontWeight(.semibold)) {
                    Stepper(value: $expectedCourseMark, in: 18...31, label: {
                        Text(expectedCourseMark <= 30 ? "\(expectedCourseMark)" : "30L").font(.title)
                    })
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                ListView {
                    Button(action: {
                        isPassed.toggle()
                    }, label: {
                        HStack {
                            Text(isPassed ? "Passed (singular)" : "Not passed (singular)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            Image(systemName: isPassed ? "checkmark.seal" : "xmark.seal" )
                                .foregroundColor(isPassed ? Color.green : Color.red)
                        }
                        .card()
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                if isPassed {
                    ListView(header: Text("Obtained mark").fontWeight(.semibold)) {
                        VStack {
                            Stepper(value: $courseMark, in: 18...31, label: {
                                Text(courseMark <= 30 ? "\(courseMark)" : "30L").font(.title)
                            })
                            .padding()
                            .background(Color("cardBackground"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                if editCourseMode {
                    ListView {
                        Button(action: {
                            viewModel.deleteCourse(withId: course!.id)
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

            .navigationBarTitle("Add course", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSavePressed()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()

                    }
                }
            }
        }
        .onAppear(perform: setupCourse)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Some fields are not compiled"),
                message: Text("You have at least to provide a title"),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }

    private func setupCourse() {
        if let course = course {
            logger.log("Did set \(course)")
            self.title = course.name
            self.courseMark = course.mark != 0 ? Int(course.mark) : 25
            self.expectedCourseMark = Int(course.expectedMark)
            self.courseCfu = Int(course.cfu)
            self.isPassed = course.mark != 0
            self.color = Color(hex: course.color)!
            self.glyph = course.iconName

            self.editCourseMode = true
        }
    }

    private func onSavePressed() {
        guard !title.isEmpty else {
            showAlert.toggle()
            return
        }
        if !editCourseMode {
            viewModel.addCourse(
                name: title,
                cfu: courseCfu,
                color: color.toHex!,
                expectedMark: expectedCourseMark,
                iconName: glyph,
                laude: isPassed ? false : false,
                expectedLaude: false,
                mark: isPassed ? courseMark : 0
            )
        } else {
            viewModel.update(
                withId: course!.id,
                name: title,
                cfu: courseCfu,
                color: color.toHex!,
                expectedMark: expectedCourseMark,
                iconName: glyph,
                laude: isPassed ? false : false,
                expectedLaude: false,
                mark: isPassed ? courseMark : 0
            )
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ExamForm_Previews: PreviewProvider {
    @State private static var title: String = "title"

    static var previews: some View {
        CourseForm(course: nil).colorScheme(.dark)
    }
}
