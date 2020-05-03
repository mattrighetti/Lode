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
    
    @ObservedObject var viewModel: ViewModel
    
    @State var showForm: Bool = false
    @State var addReminderPressed: Bool = false
    @State var pickerData = []

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.assignments, id: \.id) { assignment in
                    ReminderRow(assignment: assignment).listRowBackground(Color("background"))
                }.onDelete { IndexSet in
                    let deletedItem = self.viewModel.assignments[IndexSet.first!]
                    self.managedObjectContext.delete(deletedItem)
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                }
                
                Button(action: {
                    self.showForm.toggle()
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "plus.circle").foregroundColor(Color("bw"))
                            Spacer()
                            Text("Add reminder")
                                .fontWeight(.bold)
                                .foregroundColor(Color("bw"))
                        }
                        Spacer()
                    }
                })
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 25)
                .onLongPressGesture(
                    minimumDuration: 0.0001,
                    maximumDistance: .infinity,
                    pressing: { pressing in
                        self.addReminderPressed.toggle()
                    },
                    perform: {  }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 1,
                                dash: [7]
                            )
                        )
                        .foregroundColor(addReminderPressed ? .red : Color("bw"))
                )
                .listRowBackground(Color("background"))
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
            ReminderForm()
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct ReminderRow: View {

    var assignment: Assignment

    var body: some View {
        ZStack {
            Color("cardBackground")
            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color.gradientsPalette[Int(assignment.colorRowIndex)][Int(assignment.colorColumnIndex)])

                    VStack {
                        Text("\(assignment.daysLeft)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        Text("missing")
                            .foregroundColor(.white)
                    }
                }.frame(width: 100, height: 80, alignment: .center)

                VStack(alignment: .leading) {
                    Text(assignment.title ?? "No title")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom)

                    Text(assignment.caption ?? "No description")
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
        if assignment.daysLeft < 5 {
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
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    static var previews: some View {
        RemindersView(viewModel: ViewModel(context: context!))
            .previewDevice("iPhone 11")
            .environment(\.colorScheme, .dark)
    }
}
