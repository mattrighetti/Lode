//
//  ExamForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamForm: View {

    @Environment(\.presentationMode) var presentatitonMode
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var title: String = ""
    @State private var difficulty: Int = 1
    @State private var date: Date = Date()
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var iconIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var isExamPassed: Bool = false
    @State private var examMark: Int = 25
    @State private var examCfu: Int = 5

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
                    
                    HeaderCaption(title: "CFU", caption: "Ore totali: \(self.examCfu * 25)").padding(.top)
                    
                    CustomStepper(value: $examCfu, maxValue: 180, minValue: 1)
                    
                    Header(title: "Difficulty").padding(.top)
                    
                    Picker(selection: $difficulty, label: Text("")) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                
                }
                
                Button(action: {
                    self.isExamPassed.toggle()
                }, label: {
                    HStack {
                        Text("Passed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        Image(systemName: self.isExamPassed ? "checkmark.seal" : "xmark.seal" )
                            .foregroundColor(self.isExamPassed ? Color.green : Color.red)
                    }
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                .padding(.top)
                
                HeaderCaption(
                    title: self.isExamPassed ? "Mark Obtained" : "Mark Expected",
                    caption: self.isExamPassed ? "The mark you got" : "This will be used for further statistics"
                ).padding(.top)
                
                CustomStepper(value: $examMark, maxValue: 31, minValue: 18)
                
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
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                .padding(.top)

                HStack {
                    Spacer()
                    if self.isShowingDatePicker {
                        DatePicker(selection: self.$date, in: Date()..., displayedComponents: .date) {
                            EmptyView()
                        }.labelsHidden()
                    }
                    Spacer()
                }
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .transition(.scale)
                
            }
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))

            .navigationBarTitle("Add exam", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentatitonMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                        self.addExam()
                        self.presentatitonMode.wrappedValue.dismiss()
                }
            )
        }
    }

    func addExam() {
        let newExam = Exam(context: managedObjectContext)
        newExam.title = title.isEmpty ? "No title" : title
        newExam.iconName = Glyph.glyphArray[iconIndex.row][iconIndex.column]
        newExam.difficulty = 3
        newExam.colorRowIndex = Int16(colorIndex.row)
        newExam.colorColIndex = Int16(colorIndex.column)
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func incrementMark() {
        if self.examMark < 31 {
            self.examMark += 1
        }
    }
    
    func decrementMark() {
        if self.examMark > 18 {
            self.examMark -= 1
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
        ExamForm().colorScheme(.dark)
    }
}
