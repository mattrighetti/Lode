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

    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    var courses: FetchedResults<Course>
    
    @State var addCourseModalShown: Bool = false
    @State var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive
    @State private var courseToEdit: Course?
    @State private var showDescription: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(coursesFiltered(withTag: pickerSelection), id: \.id) { course in
                        CourseRow(course: course)
                                .onTapGesture {
                                    self.courseToEdit = course
                                    if editMode == .active {
                                        self.addCourseModalShown.toggle()
                                    }
                                }
                    }.onDelete(perform: deleteCourse)

                    Button(action: {
                        self.addCourseModalShown.toggle()
                    }, label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: "plus.circle")
                                Spacer()
                                Text("Add course")
                                        .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    })
                    .segmentedButton()
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
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
                trailing: Button(
                    action: { self.addCourseModalShown.toggle() },
                    label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                )
            )
            .environment(\.editMode, $editMode)
            .sheet(isPresented: self.$addCourseModalShown, onDismiss: {
                if editMode == .active {
                    self.editMode = .inactive
                    self.courseToEdit = nil
                }
            }, content: {
                CourseForm(course: editMode == .active ? courseToEdit : nil)
            })
        }.onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
    }
}

extension CoursesView {
    private func coursesFiltered(withTag tag: Int) -> [Course] {
        NSLog("Filtering courses", courses.compactMap{ course in course })
        let activeFilter: (Course) -> Bool = { $0.mark != 0 ? false : true }
        let passedFilter: (Course) -> Bool = { $0.mark != 0 ? true : false }

        switch tag {
        case 0:
            return courses.filter(activeFilter)
        case 1:
            return courses.filter(passedFilter)
        default:
            return courses.compactMap { course in course }
        }
    }

    private func deleteCourse(at offsets: IndexSet) {
        let deletedItem = coursesFiltered(withTag: pickerSelection)[offsets.first!]
        managedObjectContext.delete(deletedItem)

        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView().colorScheme(.dark)
    }
}