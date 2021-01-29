//
//  ExamsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 21/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import CoreData
import SwiftUI

struct ExamsView: View {

    private var columnsLayout: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        } else {
            return [GridItem(.flexible())]
        }
    }

    @ObservedObject private var sheet = SheetState()
    @StateObject private var viewModel = ExamViewViewModel()

    @State private var examPickerSelection: Int = 0
    @State private var presentAlert: Bool = false
    @State private var editMode = EditMode.inactive

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columnsLayout) {
                    ForEach(examPickerSelection == 0 ? viewModel.upcomingExams : viewModel.pastExams, id: \.title) { exam in
                        ExamRow(exam: exam)
                            .onTapGesture {
                                if editMode == .active {
                                    sheet.examToEdit = exam
                                }
                            }
                    }

                    Button(action: {
                        showModal()
                    }, label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: "plus.circle").foregroundColor(Color("bw"))
                                Spacer()
                                Text("Add exam")
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

            .navigationBarTitle("Exams")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: { EditButton() })
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Picker("", selection: $examPickerSelection) {
                            Text("Upcoming").tag(0)
                            Text("Past").tag(1)
                        }
                        .foregroundColor(Color.blue)
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        Button(
                            action: { showModal() },
                            label: { Image(systemName: "plus.circle").font(.system(size: 20)) }
                        )
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        .alert(isPresented: self.$presentAlert) {
            Alert(
                title: Text("No active course is present"),
                message: Text("You must first add an active course to be able to add exams"),
                dismissButton: .cancel(Text("Ok"))
            )
        }
        .onAppear {
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        .sheet(
            isPresented: $sheet.isShowing,
            onDismiss: {
                sheet.examToEdit = nil
                self.editMode = .inactive
            },
            content: {
                ExamForm(exam: sheet.examToEdit)
        })
    }
    
    private func showModal() {
        if viewModel.courseNotPassedStrings.isEmpty {
            self.presentAlert.toggle()
        } else {
            sheet.isShowing = true
        }
    }
}

fileprivate class SheetState: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var examToEdit: Exam? = nil {
        didSet {
            isShowing = examToEdit != nil
        }
    }
}

struct ExamsView_Previews: PreviewProvider {
    static var previews: some View {
        ExamsView()
    }
}
