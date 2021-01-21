//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

class StatsViewViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

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

    @AppStorage("laudeValue") var laudeValue: Int = 30 {
        willSet {
            average = calculateAverage(withCourses: courses, laudeValue: newValue)
            // Update Expected Average
            expectedAverage = calculateExpectedAverage(withCourses: courses, laudeValue: newValue)
        }
    }

    // Courses dependent values
    @AppStorage("totalCfu") var totalCfu: Int = 0
    @Published var gainedCfu: Int = 0
    @Published var average: Double = 0.0
    @Published var expectedAverage: Double = 0.0
    @Published var projectedGraduationGrade: Double = 0.0
    @Published var expectedGraduationGrade: Double = 0.0
    @Published var passedExams: Int = 0
    @Published var passedAsExpected: Int = 0
    @Published var passedWorseThanExpected: Int = 0
    @Published var passedBetterThanExpected: Int = 0

    private func calculateAverage(withCourses courses: FetchedResults<Course>, laudeValue: Int) -> Double {
        var average = courses.filter { $0.mark != 0 }.map {
            Double($0.cfu) * (Bool(truncating: $0.laude!) ? Double(laudeValue) : Double($0.mark))
        }.reduce(0, { $0 + $1 })
        average /= Double(gainedCfu)

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

    private func calculateGraduationGrade(withMean mean: Double) -> Double { mean * 110 / 30 }
}