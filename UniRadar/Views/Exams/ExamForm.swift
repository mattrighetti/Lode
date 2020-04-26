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
    @State private var iconName: String = "pencil"
    @State private var difficulty: Int = 1
    @State private var date: Date = Date()
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var activeColorNavigationLink: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                NavigationLink(
                    destination: GradientPickerView(gradientIndex: $colorIndex, iconName: $iconName),
                    isActive: $activeColorNavigationLink
                ) {
                    ZStack {
                        Circle()
                            .stroke()
                            .fill(Color.blue)
                            .frame(width: 105, height: 105, alignment: .center)

                        Circle()
                            .fill(Color.gradientsPalette[colorIndex.row][colorIndex.column])
                            .frame(width: 100, height: 100, alignment: .center)

                        Image(systemName: iconName)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                    }.padding(.top, 50)
                }
                
                HStack {
                    Text("Info").font(.headline).fontWeight(.bold)
                    Spacer()
                }
                .padding(.top)
                
                TextField("Exam title", text: $title)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Difficulty").font(.headline).fontWeight(.bold).padding(.bottom, 0)
                        Text("").font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.top)
                
                Picker(selection: $difficulty, label: Text("")) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Exam Date").font(.headline).fontWeight(.bold).padding(.bottom, 15)
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
                    }
                    Spacer()
                }
                .padding(.top)

                DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                    EmptyView()
                }
                .labelsHidden().padding(.horizontal)
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
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
        newExam.iconName = iconName
        newExam.difficulty = 3
        newExam.colorRowIndex = Int16(colorIndex.row)
        newExam.colorColIndex = Int16(colorIndex.column)
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }

}

struct ExamForm_Previews: PreviewProvider {
    @State private static var title: String = "title"

    static var previews: some View {
        ExamForm().colorScheme(.dark)
    }
}
