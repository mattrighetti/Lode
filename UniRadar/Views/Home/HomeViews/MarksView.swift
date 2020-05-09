//
//  MarksView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MarksView: View {

    @State var courses: [Course]

    var body: some View {
        List {
            ForEach(courses, id: \.id) { course in
                MarkCard(course: course)
                    .listRowBackground(Color("background"))
            }.onDelete(perform: removeItems)
        }

        .navigationBarTitle("Marks")
        .navigationBarItems(
            trailing:
                HStack {
                    EditButton()
                    Button(action: {
                        print("Add mark")
                    }, label: {
                        Image("plus.circle")
                    })
                }
        )
    }

    func removeItems(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
    }

}

struct MarkCard: View {

    var course: Course

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
                        Text(course.name!).font(.headline).fontWeight(.bold)
                        Text("CFU: \(course.cfu)").font(.subheadline)
                    }
                    Spacer()
                    VStack {
                        Text(course.mark == 0 ? String(course.expectedMark) : String(course.mark)).font(.title)
                        Image(systemName: markIcon()).foregroundColor(markIconColor())
                        Text(course.mark != 0 ? "Passed" : "Expected")
                    }.padding(.trailing, 5)
                }
            }.padding()
        }.cornerRadius(25)
    }

    func markIcon() -> String {
        guard course.mark != 0 else {
            return "questionmark.circle"
        }

        if course.mark >= course.expectedMark {
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
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    @ObservedObject static var viewModel: ViewModel = ViewModel(context: context!)
    static var previews: some View {
        MarksView(courses: viewModel.courses)
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .light)
    }
}
