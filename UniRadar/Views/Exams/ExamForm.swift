//
//  CourseForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamForm: View {
    
    @Environment(\.presentationMode) var presentatitonMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var name: String = ""
    @State private var course: String = ""
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var iconIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var date: Date = Date()
    
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var showCourses: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
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
                
                Header(title: "Course").padding(.top)
                
                NavigationLink(
                    destination: Text("ToDo Course List"),
                    isActive: $showCourses,
                    label: {
                        HStack {
                            Text(course.isEmpty ? "Course" : course)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color("cardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                )
                
                Header(title: "Description").padding(.top)
                
                TextField("Course name", text: $name)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Something went wrong"), message: Text("Retry later."), dismissButton: .cancel())
            }

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
    
    private func addExam() {
        let newExam = Course(context: managedObjectContext)
        newExam.id = UUID()
        newExam.name = name.isEmpty ? "No title" : name
        newExam.colorColIndex = Int16(colorIndex.column)
        newExam.colorRowIndex = Int16(colorIndex.row)
        
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
    static var previews: some View {
        CourseForm().colorScheme(.dark).accentColor(.darkRed)
    }
}
