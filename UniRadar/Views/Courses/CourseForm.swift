//
//  ExamForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CourseForm: View {

    @Environment(\.presentationMode) var presentatitonMode
    @Environment(\.managedObjectContext) var managedObjectContext

    // Course Data
    @State private var title: String = ""
    @State private var difficulty: Int = 1
    @State private var courseMark: Int = 25
    @State private var courseCfu: Int = 5
    @State private var isPassed: Bool = false
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var iconIndex: GridIndex = GridIndex(row: 0, column: 1)
    
    // View Data
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Group {
                    NavigationLink(
                        destination: ColorPickerView(colorIndex: $colorIndex, glyphIndex: $iconIndex),
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
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
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
                
                Button(action: {
                    self.isPassed.toggle()
                }, label: {
                    HStack {
                        Text("Passed")
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
                
                HeaderCaption(
                    title: self.isPassed ? "Mark Obtained" : "Mark Expected",
                    caption: self.isPassed ? "The mark you got" : "This will be used for further statistics"
                ).padding(.top)
                
                CustomStepper(value: $courseMark, maxValue: 31, minValue: 18)
                
            }
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))

            .navigationBarTitle("Add exam", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentatitonMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                        self.addCourse()
                        self.presentatitonMode.wrappedValue.dismiss()
                }
            )
        }
    }

    private func addCourse() {
        let newCourse = Course(context: managedObjectContext)
        newCourse.name = title.isEmpty ? "No title" : title
        newCourse.cfu = Int16(courseCfu)
        newCourse.colorRowIndex = Int16(colorIndex.row)
        newCourse.colorColIndex = Int16(colorIndex.column)
        newCourse.iconColIndex = Int16(iconIndex.column)
        newCourse.iconRowIndex = Int16(iconIndex.row)
        
        if isPassed {
            newCourse.mark = Int16(courseMark)
        } else {
            newCourse.expectedMark = Int16(courseMark)
        }
        
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
            Text(title)
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
                Text(title).font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                Text(caption)
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
