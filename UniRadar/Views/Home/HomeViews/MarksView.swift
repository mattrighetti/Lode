//
//  MarksView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MarksView: View {
    
    @State var marks: [Mark] = [
        Mark(subjectName: "Analisi 1", expectedMark: 28, finalMark: 27, difficulty: 3, datePassed: Date()),
        Mark(subjectName: "Analisi 2", expectedMark: 28, finalMark: 29, difficulty: 3, datePassed: Date()),
        Mark(subjectName: "ACA", expectedMark: 28, difficulty: 3, datePassed: Date()),
        Mark(subjectName: "AAPP", expectedMark: 28, difficulty: 3, datePassed: Date()),
        Mark(subjectName: "Computer Graphics", expectedMark: 28, difficulty: 3, datePassed: Date())
    ]
    
    var body: some View {
        List {
            ForEach(marks, id: \.id) { mark in
                MarkCard(mark: mark)
                    .listRowBackground(Color("background"))
            }.onDelete(perform: removeItems)
        }
        
        .navigationBarTitle("Marks")
        .navigationBarItems(trailing:
            HStack {
                EditButton()
                Button(action: {
                    print("Add mark")
                }) {
                    Image("plus.circle")
                }
            }
        )
    }
    
    func removeItems(at offsets: IndexSet) {
        marks.remove(atOffsets: offsets)
    }
    
}

struct MarkCard: View {
    
    var mark: Mark
    
    var body: some View {
        ZStack {
            Color("cardBackground")
            VStack {
                HStack {
                    Text("#01").font(.subheadline).fontWeight(.heavy).foregroundColor(.darkRed)
                    Spacer()
                }
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(mark.subjectName).font(.headline).fontWeight(.bold)
                        Text(mark.datePassedString).font(.subheadline)
                    }
                    Spacer()
                    VStack {
                        Text(mark.finalMark != nil ? String(mark.finalMark!) : String(mark.expectedMark)).font(.title)
                        Image(systemName: markIcon()).foregroundColor(markIconColor())
                        Text(mark.finalMark != nil ? "Passed" : "Expected")
                    }.padding(.trailing, 5)
                    Divider()
                    Image(systemName: "chevron.right").padding(20)
                }
            }.padding()
        }.cornerRadius(25)
    }
    
    func markIcon() -> String {
        guard let finalMark = mark.finalMark else {
            return "questionmark.circle"
        }
        
        if finalMark >= mark.expectedMark {
            return "checkmark.seal"
        }
        
        return "xmark.seal"
    }
    
    func markIconColor() -> Color {
        let markIconValue = markIcon()
        
        if markIconValue == "questionmark.circle" {
            return Color.orange
        }
        
        if markIconValue == "checkmark.seal" {
            return Color.green
        }
        
        return Color.red
    }
    
}

struct MarksView_Previews: PreviewProvider {
    static var previews: some View {
        MarksView()
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .light)
    }
}
