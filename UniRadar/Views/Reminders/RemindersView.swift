//
//  RemindersView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import CoreData
import SwiftUI

struct RemindersView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var viewModel: ViewModel
    
    @State var showForm: Bool = false
    @State var addReminderPressed: Bool = false
    @State var pickerSelection: Int = 0

    var body: some View {
        NavigationView {
            List {
                ForEach(assignmentsFiltered(withTag: pickerSelection), id: \.id) { assignment in
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
                .modifier(SegmentedButton())
                .listRowBackground(Color("background"))
            }

            .navigationBarTitle("Assignments")
            .navigationBarItems(
                leading: EditButton(),
                center: AnyView(
                    Picker(selection: $pickerSelection, label: Text("Picker")) {
                        Text("Current").tag(0)
                        Text("Past").tag(1)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                ),
                trailing: Button(
                    action: { self.showForm.toggle() },
                    label: { Image(systemName: "plus.circle")
                })
            )
        }
        .sheet(isPresented: $showForm) {
            ReminderForm()
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
    
    private func assignmentsFiltered(withTag tag: Int) -> [Assignment] {
        let upcomingFilter: (Assignment) -> Bool = { $0.dueDate! > Date() }
        let pastFilter: (Assignment) -> Bool = { $0.dueDate! <= Date() }
        
        switch tag {
        case 0:
            return viewModel.assignments.filter(upcomingFilter)
        case 1:
            return viewModel.assignments.filter(pastFilter)
        default:
            return viewModel.assignments
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
        }
        .modifier(CardStyle())
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
