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
    
    @ObservedObject private var sheet = SheetState()
    @StateObject private var viewModel = CourseViewViewModel()

    private var columnsLayout: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        } else {
            return [GridItem(.flexible())]
        }
    }

    @State var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive
    @State private var showDescription: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columnsLayout) {
                    ForEach(pickerSelection == 0 ? viewModel.activeCourses : viewModel.passedCourses, id: \.id) { course in
                        CourseRow(course: course)
                            .onTapGesture {
                                sheet.courseToEdit = course
                            }
                    }

                    Button(action: {
                        sheet.isShowing = true
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
                    action: {  },
                    label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                )
            )
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $sheet.isShowing, onDismiss: {
                sheet.courseToEdit = nil
            }, content: {
                CourseForm(course: sheet.courseToEdit)
            })
        }.onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
    }
}

fileprivate class SheetState: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var courseToEdit: Course? = nil {
        didSet {
            isShowing = courseToEdit != nil
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView().colorScheme(.dark)
    }
}
