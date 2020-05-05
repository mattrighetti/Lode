//
//  CoursesView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CoursesView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var viewModel: ViewModel
    
    @State var addCourseModalShown: Bool = false
    @State var pickerSelection: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.courses, id: \.id) { course in
                    CourseRow(course: course)
                        .listRowBackground(Color("background"))
                }.onDelete { IndexSet in
                    let deletedItem = self.viewModel.courses[IndexSet.first!]
                    self.managedObjectContext.delete(deletedItem)
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                }
                
                Button(action: {
                        self.addCourseModalShown.toggle()
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "plus.circle").foregroundColor(Color("bw"))
                            Spacer()
                            Text("Add course")
                                .fontWeight(.bold)
                                .foregroundColor(Color("bw"))
                        }
                        Spacer()
                    }
                })
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 1,
                                dash: [7]
                            )
                        )
                        .foregroundColor(Color("bw"))
                ).listRowBackground(Color("background"))
            }
            
            .navigationBarTitle("Courses")
            .navigationBarItems(
                leading: EditButton(),
                center: AnyView(
                    Picker(selection: $pickerSelection, label: Text("Picker")) {
                        Text("Active").tag(0)
                        Text("Passed").tag(1)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                ),
                trailing: Button(action: { self.addCourseModalShown.toggle() }, label: { Image(systemName: "plus.circle") })
            )
            .sheet(isPresented: $addCourseModalShown) {
                CourseForm()
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }
    
    private func coursesFiltered(withTag tag: Int) -> [Course] {
        // TODO - This is not a good closure, recheck
        let activeFilter: (Course) -> Bool = { Int($0.mark) > 17 }
        let passedFilter: (Course) -> Bool = { Int($0.mark) < 17 }
        
        switch tag {
        case 0:
            return viewModel.courses.filter(activeFilter)
        case 1:
            return viewModel.courses.filter(passedFilter)
        default:
            return viewModel.courses
        }
    }
    
}

struct CourseRow: View {
    
    var course: Course
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.gradientsPalette[Int(course.colorRowIndex)][Int(course.colorColIndex)])
                Image(systemName: course.iconName ?? "pencil").font(.system(size: 30))
            }
            .frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(course.name ?? "No name")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Divider()
                
                Text("CFU: \(course.cfu)")
            }
            Spacer()
            Divider()
            VStack(alignment: .center) {
                Text("Passed")
                Image(systemName: "checkmark")
            }
        }
        .padding()
        .background(Color("cardBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct CoursesView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        CoursesView(viewModel: ViewModel(context: context!)).colorScheme(.dark)
    }
}
