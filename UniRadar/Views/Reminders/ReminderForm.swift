//
//  ReminderForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderForm: View {
    
    // Does automatically the job to get the dismiss Bool of the View that launches this as sheet
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var colorIndex: GridIndex = GridIndex(row: 0, column: 3)
    @State private var iconIndex: GridIndex = GridIndex(row: 0, column: 3)
    @State private var activeColorNavigationLink: Bool = false
    @State private var isShowingDatePicker: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: ColorPickerView(colorIndex: $colorIndex, glyphIndex: $iconIndex),
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

                        Image(systemName: Glyph.glyphArray[iconIndex.row][iconIndex.column])
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                    }.padding(.top, 50)
                }
                
                HStack {
                    Text("Info").font(.headline).fontWeight(.bold)
                    Spacer()
                }
                .padding(.top)
                
                TextField("Assignment title", text: $title)
                    .padding()
                    .background(Color("cardBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                TextField("Assignment description", text: $title)
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
                
            .navigationBarTitle("Add reminder", displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Cancel")
                    }
                ),
                trailing: Button(
                    action: {
                        print("Saving")
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Save")
                    }
                )
            )
        }
    }
}

struct ReminderForm_Previews: PreviewProvider {
    static var previews: some View {
        ReminderForm()
            .environment(\.colorScheme, .dark)
    }
}
