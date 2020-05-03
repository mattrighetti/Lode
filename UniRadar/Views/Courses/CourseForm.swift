//
//  CourseForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CourseForm: View {
    
    @Environment(\.presentationMode) var presentatitonMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var name: String = ""
    @State private var cfu: Int = 5
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var iconIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var activeColorNavigationLink: Bool = false
    
    @State private var showAlert: Bool = false
    
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
                
                Header(title: "Name").padding(.top)
                
                TextField("Course name", text: $name)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                HeaderCaption(title: "CFU", caption: "Ore totali: \(self.cfu * 25)").padding(.top)
                
                CustomStepper(value: $cfu, maxValue: 180, minValue: 1)
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
                    self.addCourse()
                    self.presentatitonMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func addCourse() {
        let newCourse = Course(context: managedObjectContext)
        newCourse.id = UUID()
        newCourse.name = name.isEmpty ? "No title" : name
        newCourse.cfu = Int16(cfu)
        newCourse.colorColIndex = Int16(colorIndex.column)
        newCourse.colorRowIndex = Int16(colorIndex.row)
        newCourse.iconName = Glyph.glyphArray[iconIndex.row][iconIndex.column]
        
        saveContext()
    }
    
    func saveContext() {
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
