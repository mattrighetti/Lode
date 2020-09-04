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
    
    // DataModel main elements
    @Published var exams: [Exam] = []
    @Published var assignments: [Assignment] = []
    @Published var courses: [Course] = []
    
    @Published var laudeValue: Int = 30
    
    // Courses dependent values
    @Published var totalCfu: Int = 0
    @Published var gainedCfu: Int = 0
    @Published var average: Double = 0.0
    @Published var expectedAverage: Double = 0.0
    @Published var projectedGraduationGrade: Double = 0.0
    @Published var expectedGraduationGrade: Double = 0.0
    @Published var passedExams: Int = 0
    @Published var passedAsExpected: Int = 0
    @Published var passedWorseThanExpected: Int = 0
    @Published var passedBetterThanExpected: Int = 0
    
    // Exams dependent values
    @Published var upcomingExams: Int = 0
    
    // Assignments dependent values
    @Published var dueSoonAssignments: Int = 0
    
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
                print("Completed Exams Fetch Request Sub")
            }, receiveValue: { newExams in
                self.exams = newExams
            })
            .store(in: &cancellables)
        
        FetchedResultsPublisher(request: Assignment.fetchRequest(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("Completed Assignments Fetch Request Sub")
            }, receiveValue: { newAssignments in
                self.assignments = newAssignments
            })
            .store(in: &cancellables)
        
        FetchedResultsPublisher(request: Course.fetchRequest(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("Completed Course Fetch Request Sub")
            }, receiveValue: { newCourses in
                self.courses = newCourses
            })
            .store(in: &cancellables)
        
        self.$courses.sink(receiveValue: { courses in
            // Update CFU
            self.gainedCfu = courses.filter { $0.mark != 0 }.map { Int($0.cfu) }.reduce(0) { $0 + $1 }
            // Update Average
            self.average = self.calculateAverage(withCourses: courses, laudeValue: self.laudeValue)
            // Update Expected Average
            self.expectedAverage = self.calculateExpectedAverage(withCourses: courses, laudeValue: self.laudeValue)
            // Update Projected Grad Grade
            self.projectedGraduationGrade = self.calculateGraduationGrade(withMean: self.average)
            // Update Expected Projected Grad Grade
            self.expectedGraduationGrade = self.calculateGraduationGrade(withMean: self.expectedAverage)
            // Update Passed Exams
            self.passedExams = courses.filter { $0.mark != 0 }.count
            // Other values
            self.passedAsExpected = courses.filter { $0.mark != 0 && $0.mark == $0.expectedMark }.count
            self.passedWorseThanExpected = courses.filter { $0.mark != 0 && $0.mark < $0.expectedMark }.count
            self.passedBetterThanExpected = courses.filter { $0.mark != 0 && $0.mark > $0.expectedMark }.count
        })
        .store(in: &cancellables)
        
        self.$laudeValue.sink(receiveValue: { laudeValue in
            self.average = self.calculateAverage(withCourses: self.courses, laudeValue: laudeValue)
            // Update Expected Average
            self.expectedAverage = self.calculateExpectedAverage(withCourses: self.courses, laudeValue: laudeValue)
        })
        .store(in: &cancellables)
        
    }
    
    private func calculateAverage(withCourses courses: [Course], laudeValue: Int) -> Double {
        var average = courses.filter { $0.mark != 0 }.map {
            Double($0.cfu) * (Bool(truncating: $0.laude!) ? Double(laudeValue) : Double($0.mark))
        }.reduce(0, { $0 + $1 })
        average /= Double(self.gainedCfu)
        
        guard !average.isNaN else { return 0.0 }
        
        return average
    }
    
    private func calculateExpectedAverage(withCourses courses: [Course], laudeValue: Int) -> Double {
        var average = courses.map {
            Double($0.cfu) * (Bool(truncating: $0.expectedLaude!) ? Double(laudeValue) : Double($0.expectedMark))
        }.reduce(0, { $0 + $1 })
        
        let totalCfu = courses.map { Double($0.cfu) }.reduce(0, { $0 + $1 })
        average /= totalCfu
        
        guard !average.isNaN else { return 0.0 }
        
        return average
    }
    
    private func calculateGraduationGrade(withMean mean: Double) -> Double {
        return mean * 110 / 30
    }
    
    public func storeInUserDefaults() {
        UserDefaults.standard.set(self.totalCfu, forKey: "totalCfu")
        UserDefaults.standard.set(self.laudeValue, forKey: "laudeValue")
    }
    
    public func calculateDeltas(withCfu cfu: Int) -> [Double] {
        var deltas = [Double]()
        let average = courses.filter { $0.mark != 0 }.map { Double($0.mark * $0.cfu) }.reduce(0, { $0 + $1 })
        let gainedCfu = Double(self.gainedCfu) + Double(cfu)
        
        guard gainedCfu != 0 else {
            for mark in 18...30 {
                deltas.append(Double(mark))
            }
            
            return deltas
        }
        
        var tmp = 0.0
        for mark in 18...30 {
            tmp = average
            tmp += (Double(mark) * Double(cfu))
            tmp /= gainedCfu
            deltas.append(tmp)
        }
        
        return deltas
    }
    
}
