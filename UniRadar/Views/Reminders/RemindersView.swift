//
//  RemindersView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import CoreData
import SwiftUI

struct Reminder: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let expirationDate: Date
}

struct RemindersView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity:Exam.entity(),sortDescriptors:[]) var exams: FetchedResults<Exam>
    
    @State var showForm: Bool = false
    @State var pickerData = []

    var body: some View {
        NavigationView {
            List {
                ReminderRow(
                    title: "AAPP assignment", description: "Make the OpenMP algorithm challenge", daysLeft: 3
                ).listRowBackground(Color("background"))
                ReminderRow(
                    title: "AAPP assignment", description: "Make the OpenMP algorithm challenge", daysLeft: 7
                ).listRowBackground(Color("background"))
                ReminderRow(
                    title: "AAPP assignment", description: "Make the OpenMP algorithm challenge", daysLeft: 1
                ).listRowBackground(Color("background"))
                
                Button(action: {
                    self.showForm.toggle()
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "plus.circle")
                            Spacer()
                            Text("Add reminder").fontWeight(.bold)
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [7]
                            )
                        )
                        .foregroundColor(.white)
                ).listRowBackground(Color("background"))
            }

            .navigationBarTitle("Assignments")
            .navigationBarItems(
                leading: EditButton(),
                center: AnyView(
                    Picker(selection: .constant(1), label: Text("Picker")) {
                        Text("Current").tag(1)
                        Text("Past").tag(2)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                ),
                trailing: Button(
                    action: { self.showForm.toggle() }, label: { Image(systemName: "plus.circle") })
            )
        }
        .sheet(isPresented: $showForm) {
            ReminderForm().environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct ReminderRow: View {

    var title: String
    var description: String
    var daysLeft: Int
    var colors: [Color] = [.flatDarkRed, .flatLightRed]

    var body: some View {
        ZStack {
            Color("cardBackground")
            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: colors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack {
                        Text("\(daysLeft)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        Text("missing")
                            .foregroundColor(.white)
                    }
                }.frame(width: 100, height: 80, alignment: .center)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom)

                    Text(description)
                        .font(.caption)
                        .lineLimit(2)

                    isDueSoon()
                }

                Spacer()
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }

    func isDueSoon() -> some View {
        if daysLeft < 5 {
            return AnyView(
                HStack {
                    Image(systemName: "exclamationmark.circle")
                    Text("Due soon")
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.flatLightRed)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
            )
        } else {
            return AnyView(
                EmptyView()
            )
        }
    }

}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .dark)
    }
}
