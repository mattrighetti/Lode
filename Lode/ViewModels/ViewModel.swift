//
//  ViewModel.swift
//  UniRadar
//
//  Created by Mattia Righetti on 27/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Combine
import CoreData
import SwiftUI

class ViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    public static var shared: ViewModel = ViewModel()
    
    // DataModel main elements
    @FetchRequest(entity: Exam.entity(), sortDescriptors: [])
    var exams: FetchedResults<Exam>

    @FetchRequest(entity: Assignment.entity(), sortDescriptors: [])
    var assignments: FetchedResults<Assignment>

    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    var courses: FetchedResults<Course> {
        willSet {
            // Update CFU
            gainedCfu = newValue.filter { $0.mark != 0 }.map { Int($0.cfu) }.reduce(0) { $0 + $1 }
            // Update Average
            average = calculateAverage(withCourses: newValue, laudeValue: laudeValue)
            // Update Expected Average
            expectedAverage = self.calculateExpectedAverage(withCourses: newValue, laudeValue: laudeValue)
            // Update Projected Grad Grade
            projectedGraduationGrade = self.calculateGraduationGrade(withMean: average)
            // Update Expected Projected Grad Grade
            expectedGraduationGrade = self.calculateGraduationGrade(withMean: expectedAverage)
            // Update Passed Exams
            passedExams = newValue.filter { $0.mark != 0 }.count
            // Other values
            passedAsExpected = newValue.filter { $0.mark != 0 && $0.mark == $0.expectedMark }.count
            passedWorseThanExpected = newValue.filter { $0.mark != 0 && $0.mark < $0.expectedMark }.count
            passedBetterThanExpected = newValue.filter { $0.mark != 0 && $0.mark > $0.expectedMark }.count
        }
    }

    @Published var laudeValue: Int = 30 {
        willSet {
            average = calculateAverage(withCourses: courses, laudeValue: newValue)
            // Update Expected Average
            expectedAverage = calculateExpectedAverage(withCourses: courses, laudeValue: newValue)
        }
    }
    
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

    private func calculateAverage(withCourses courses: FetchedResults<Course>, laudeValue: Int) -> Double {
        var average = courses.filter { $0.mark != 0 }.map {
            Double($0.cfu) * (Bool(truncating: $0.laude!) ? Double(laudeValue) : Double($0.mark))
        }.reduce(0, { $0 + $1 })
        average /= Double(self.gainedCfu)

        guard !average.isNaN else { return 0.0 }

        return average
    }

    private func calculateExpectedAverage(withCourses courses: FetchedResults<Course>, laudeValue: Int) -> Double {
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
        UserDefaults.standard.set(totalCfu, forKey: "totalCfu")
        UserDefaults.standard.set(laudeValue, forKey: "laudeValue")
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

// MARK: - CoreData

//extension ViewModel {
//    func subs() {
//        FetchedResultsPublisher(request: Exam.fetchRequest(), context: viewContext)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in
//                print("Completed Exams Fetch Request Sub")
//            }, receiveValue: { newExams in
//                self.exams = newExams
//            })
//            .store(in: &cancellables)
//
//        FetchedResultsPublisher(request: Assignment.fetchRequest(), context: viewContext)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in
//                print("Completed Assignments Fetch Request Sub")
//            }, receiveValue: { newAssignments in
//                self.assignments = newAssignments
//            })
//            .store(in: &cancellables)
//
//        FetchedResultsPublisher(request: Course.fetchRequest(), context: viewContext)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in
//                print("Completed Course Fetch Request Sub")
//            }, receiveValue: { newCourses in
//                self.courses = newCourses
//            })
//            .store(in: &cancellables)
//    }
//}
