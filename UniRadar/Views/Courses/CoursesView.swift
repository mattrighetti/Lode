//
//  CoursesView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import CoreData

struct CoursesView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var viewModel: ViewModel
    
    @State var addCourseModalShown: Bool = false
    @State var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive
    @State private var courseToEdit: Course?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(coursesFiltered(withTag: pickerSelection), id: \.id) { course in
                    CourseRow(course: course)
                        .onTapGesture {
                            if self.editMode == .active {
                                self.courseToEdit = course
                                self.addCourseModalShown.toggle()
                            }
                        }
                        .listRowBackground(Color("background"))
                }.onDelete { IndexSet in
                    let deletedItem = self.coursesFiltered(withTag: self.pickerSelection)[IndexSet.first!]
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
                .modifier(SegmentedButton())
                .listRowBackground(Color("background"))
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
            .environment(\.editMode, $editMode)
            .sheet(isPresented: self.$addCourseModalShown, onDismiss: {
                if self.editMode == .active {
                    self.editMode = .inactive
                    self.courseToEdit = nil
                }
            }, content: {
                CourseForm(course: self.editMode == .active ? self.courseToEdit : nil)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            })
        }
    }
    
    private func coursesFiltered(withTag tag: Int) -> [Course] {
        let activeFilter: (Course) -> Bool = { $0.mark != 0 ? false : true }
        let passedFilter: (Course) -> Bool = { $0.mark != 0 ? true : false }
        
        switch tag {
        case 0:
            return viewModel.courses.filter(activeFilter)
        case 1:
            return viewModel.courses.filter(passedFilter)
        default:
            return viewModel.courses
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        
    }
    
}

struct CourseRow: View {
    
    var course: Course
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.gradientsPalette[Int(course.colorRowIndex)][Int(course.colorColIndex)])
                Image(systemName: course.iconName ?? "pencil").foregroundColor(.white).font(.system(size: 30))
            }
            .frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(course.name ?? "No name")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                Text("CFU: \(course.cfu)")
                    .modifier(BadgePillStyle(color: .orange))
                
                Text("Expected: \(course.expectedMark)")
                    .modifier(BadgePillStyle(color: .blue))
            
            }
            Spacer()
            VStack(alignment: .center) {
                Text(course.mark == 0 ? "Upcoming" :"Passed")
                Image(systemName: course.mark == 0 ? "xmark.seal" : "checkmark.seal")
                    .foregroundColor(course.mark == 0 ? .red : .green)
            }
        }
        .modifier(CardStyle())
    }
}

struct CoursesView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
//        let course = Course(context: context!)
//        course.name = "Advanced Algorithms and Parallel Programming"
//        course.cfu = 5
//        course.expectedMark = 28
//        course.mark = 28
        CoursesView(viewModel: ViewModel(context: context!)).colorScheme(.dark)
//        return List {
//            CourseRow(course: course)
//        }.colorScheme(.dark)
    }
}
