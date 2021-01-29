//
//  CoursesView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.mattrighetti.Lode", category: "CourseView")

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

    @State private var pickerSelection: Int = 0
    @State private var editMode = EditMode.inactive
    @State private var showDescription: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columnsLayout) {
                    ForEach(pickerSelection == 0 ? viewModel.activeCourses : viewModel.passedCourses, id: \.name) { course in
                        CourseRow(course: course)
                            .onTapGesture {
                                if editMode == .active {
                                    logger.log("Setting course to edit: \(course)")
                                    sheet.courseToEdit = course
                                }
                            }
                    }

                    Button(action: {
                        sheet.isShowing = true
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
                    .segmentedButton()
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
            }
            
            .navigationBarTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: { EditButton() })
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Picker(selection: $pickerSelection, label: Text("Picker")) {
                            Text("Active").tag(0)
                            Text("Passed").tag(1)
                        }
                        .foregroundColor(Color.blue)
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        Button(
                            action: { sheet.isShowing.toggle() },
                            label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                        )
                    }
                }
            }.environment(\.editMode, $editMode)
            .sheet(isPresented: $sheet.isShowing, onDismiss: {
                logger.log("Setting course to edit to value: nil")
                sheet.courseToEdit = nil
                self.editMode = .inactive
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
