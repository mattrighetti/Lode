//
//  ViewModel.swift
//  UniRadar
//
//  Created by Mattia Righetti on 27/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Combine
import CoreData

class ViewModel: ObservableObject {
    // CoreData Context
    private var managedObjectContext: NSManagedObjectContext
    
    // DataModel
    @Published var exams: [Exam] = []
    @Published var assignments: [Assignment] = []
    @Published var courses: [Course] = []
    
    // Subscriptions Pool
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func subs() {
        FetchedResultsPublisher(request: Exam.fetchRequest(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print("Fetched new data")
                print("\($0)")
            }, receiveValue: { newExams in
                self.exams = newExams
            })
            .store(in: &cancellables)
    }
    
//    func subscribeToPublishers() {
//        // Exams CoreData Publisher
//        CoreDataPublisher(request: Exam.fetchRequest(), context: self.managedObjectContext)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] newExams in
//                self?.exams = newExams
//            }
//            .store(in: &cancellables)
//
//        // Assignments CoreData Publisher
//        CoreDataPublisher(request: Assignment.fetchRequest(), context: self.managedObjectContext)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] newAssignments in
//                self?.assignments = newAssignments
//            }
//            .store(in: &cancellables)
//
//        // Assignments CoreData Publisher
//        CoreDataPublisher(request: Course.fetchRequest(), context: self.managedObjectContext)
//            .receive(on: DispatchQueue.main)
//            .sink{ [weak self] newCourses in
//                self?.courses = newCourses
//            }
//            .store(in: &cancellables)
//    }
}
