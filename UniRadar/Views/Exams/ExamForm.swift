//
//  ExamForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamForm: View {

    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding var modalDismissed: Bool

    @State private var title: String = ""
    @State private var iconName: String = "pencil"
    @State private var difficulty: Int = 1
    @State private var date: Date = Date()
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 1)
    @State private var activeColorNavigationLink: Bool = false

    var body: some View {
        NavigationView {
            VStack {
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

                Form {
                    Section(header: Text("Infos")) {
                        TextField("Exam title", text: $title)
                        HStack {
                            Text("Difficulty").padding(.trailing, 100)
                            Picker(selection: $difficulty, label: Text("")) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                            Text(date.textDateRappresentation)
                        }
                    }
                }.background(Color("background"))
                    .padding(.top)
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))

            .navigationBarTitle("Add exam", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.addExam()
                        self.modalDismissed.toggle()
                    }, label: {
                        Text("Done")
                    })
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
    @State private static var shown = false

    static var previews: some View {
        ExamForm(modalDismissed: $shown).colorScheme(.dark)
    }
}
