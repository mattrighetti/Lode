//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

class AverageDeltaViewViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    var courses: FetchedResults<Course> {
        willSet {
            // Update CFU
            gainedCfu = newValue.filter { $0.mark != 0 }.map { Int($0.cfu) }.reduce(0) { $0 + $1 }
        }
    }

    @Published var laudeValue: Int = 30 {
        willSet {
            average = calculateAverage(withCourses: courses, laudeValue: newValue)
        }
    }

    // Courses dependent values
    @Published var totalCfu: Int = 0
    @Published var gainedCfu: Int = 0
    @Published var average: Double = 0.0

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

    private func calculateGraduationGrade(withMean mean: Double) -> Double { mean * 110 / 30 }
}