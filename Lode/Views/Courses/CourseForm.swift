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
    
    @State private var editCourseMode: Bool = false

    var course: Course?
    
    private var acronym: String {
        let splitString = title
            .split { $0 == " " }
            .map { String($0).lowercased() }
            .filter { $0 != "and" && $0 != "e" && $0 != "of" }

        return splitString.map({ String($0.first!).uppercased() }).reduce("", +)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Group {
                    NavigationLink(
                        destination: IconColorPickerView(selectedColor: $color, selectedGlyph: $glyph),
                        isActive: $activeColorNavigationLink,
                        label: {
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
                            .padding(.top, 50)
                        }
                    )
                    
                    Header(title: "Title").padding(.top)
                    
                    if title.count > 30 {
                        withAnimation {
                            HStack {
                                Text("Title will be truncated to:")
                                Text(acronym)
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                            .transition(.scale)
                        }
                    }
                    
                    TextField("Course title", text: $title)
                        .card()
                    
                    HeaderCaption(title: "CFU", caption: "Ore totali: \(courseCfu * 25)").padding(.top)

                    Stepper(value: $courseCfu, in: 1...50, label: {
                        Text("\(courseCfu)").font(.title)
                    })
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                HeaderCaption(
                    title: "Mark expected",
                    caption: "This will be used for further statistics"
                ).padding(.top)

                Stepper(value: $expectedCourseMark, in: 18...31, label: {
                    Text(expectedCourseMark <= 30 ? "\(expectedCourseMark)" : "30L").font(.title)
                })
                .padding()
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Button(action: {
                    isPassed.toggle()
                }, label: {
                    HStack {
                        Text("Passed (singular)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        Image(systemName: isPassed ? "checkmark.seal" : "xmark.seal" )
                            .foregroundColor(isPassed ? Color.green : Color.red)
                    }
                    .card()
                })
                .padding(.top)
                
                VStack {
                    if isPassed {
                        HeaderCaption(
                            title: "Mark obtained",
                            caption: "The mark you got"
                        ).padding(.top)

                        Stepper(value: $courseMark, in: 18...31, label: {
                            Text(courseMark <= 30 ? "\(courseMark)" : "30L").font(.title)
                        })
                        .padding()
                        .background(Color("cardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.bottom, 50)
                .transition(.scale)

                if editCourseMode {
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
                }
                
            }
            .scrollViewWithoutBackground()
            .padding(.horizontal)
            .background(Color.background.edgesIgnoringSafeArea(.all))

            .navigationBarTitle("Add course", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") { onSavePressed() }
            )
        }
        .onAppear(perform: setupCourse)
        .navigationViewStyle(StackNavigationViewStyle())
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

struct ExamForm_Previews: PreviewProvider {
    @State private static var title: String = "title"

    static var previews: some View {
        CourseForm(course: nil).colorScheme(.dark)
    }
}
