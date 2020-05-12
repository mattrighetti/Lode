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
    @Published var totalCfu: Int = 0
    @Published var gainedCfu: Int = 0
    @Published var average: Double = 0.0
    @Published var expectedAverage: Double = 0.0
    @Published var projectedGraduationGrade: Double = 0.0
    @Published var expectedGraduationGrade: Double = 0.0
    
    // Subscriptions Pool
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        self.subs()
    }
}

// MARK: - Methods

extension ViewModel {
    
    func subs() {
        
        FetchedResultsPublisher(request: Exam.fetchRequest(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("Fetched new exams")
            }, receiveValue: { newExams in
                self.exams = newExams
            })
            .store(in: &cancellables)
        
        FetchedResultsPublisher(request: Assignment.fetchRequest(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("Fetched new assignments")
            }, receiveValue: { newAssignments in
                self.assignments = newAssignments
            })
            .store(in: &cancellables)
        
        FetchedResultsPublisher(request: Course.fetchRequest(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("Fetched new data")
            }, receiveValue: { newCourses in
                self.courses = newCourses
            })
            .store(in: &cancellables)
        
        self.$courses.sink(receiveValue: { courses in
            // Update CFU
            self.gainedCfu = courses.filter { $0.mark != 0 }.map { Int($0.cfu) }.reduce(0) { $0 + $1 }
            self.totalCfu = courses.map { Int($0.cfu) }.reduce(0, { $0 + $1 })
            // Update Average
            self.average = self.calculateAverage(withCourses: courses)
            // Update Expected Average
            self.expectedAverage = self.calculateExpectedAverage(withCourses: courses)
            // Update Projected Grad Grade
            self.projectedGraduationGrade = self.calculateGraduationGrade(withMean: self.average)
            // Update Expected Projected Grad Grade
            self.expectedGraduationGrade = self.calculateGraduationGrade(withMean: self.expectedAverage)
        }).store(in: &cancellables)
        
    }
    
    private func calculateAverage(withCourses courses: [Course]) -> Double {
        var average = courses.filter { $0.mark != 0 }.compactMap { Double($0.mark * $0.cfu) }.reduce(0, +)
        average /= Double(self.gainedCfu)
        return average
    }
    
    private func calculateExpectedAverage(withCourses course: [Course]) -> Double {
        var average = courses.compactMap { Double($0.cfu * $0.expectedMark) }.reduce(0, +)
        average /= courses.reduce(0) { $0 + Double($1.cfu) }
        return average
    }
    
    private func calculateGraduationGrade(withMean mean: Double) -> Double {
        return mean * 110 / 30
    }
    
}
