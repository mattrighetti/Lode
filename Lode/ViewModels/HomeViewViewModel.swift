//
// Created by Mattia Righetti on 24/01/21.
//

import Foundation
import Combine
import SwiftUI

class HomeViewViewModel: ObservableObject {
    @AppStorage("laudeValue") var laudeValue: Int = 30

    @Published var courses: [Course] = [] {
        willSet {
            gainedCfu = newValue.filter { $0.mark != 0 }.map { Double($0.cfu) }.reduce (0, { $0 + $1 })
            if gainedCfu == 0 {
                average = 0.0
            } else {
                average = newValue.filter { $0.mark != 0 }.map { Double($0.cfu) * Double($0.mark) }
                        .reduce(0, { $0 + $1 }) / gainedCfu
            }
            let eAverage = newValue.filter({ $0.mark != 0 }).map({
                Double($0.cfu) * (Bool(truncating: $0.expectedLaude!) ? Double(laudeValue) : Double($0.expectedMark))
            }).reduce(0, { $0 + $1 })

            let totalCfuPassed = newValue.filter({ $0.mark != 0 }).map({
                Double($0.cfu)
            }).reduce(0, { $0 + $1 })

            expectedAveragePassed = (eAverage / totalCfuPassed).isNaN ? 0.0 : eAverage / totalCfuPassed
            difference = average >= expectedAveragePassed ? average - expectedAveragePassed : expectedAveragePassed - average
            sign = average >= expectedAveragePassed ? "+" : "-"
            isAverageBiggerThanExpected = average >= expectedAveragePassed
            color = isAverageBiggerThanExpected ? .green : .red
        }
    }
    @Published var exams: [Exam] = []
    @Published var gainedCfu: Double = 0.0
    @Published var average: Double = 0.0
    @Published var expectedAveragePassed: Double = 0.0
    @Published var sign: String = "" {
        willSet {
            if newValue == "+" {
                switch difference {
                case 1...:
                    emoji = "🤯"
                case 0.1..<1:
                    emoji = "🤩"
                case 0..<0.1:
                    emoji = "👌🏻"
                default:
                    emoji = ""
                }
            } else {
                emoji = "☹️"
            }
        }
    }
    @Published var difference: Double = 0.0
    @Published var isAverageBiggerThanExpected: Bool = false
    @Published var color: Color = .clear
    @Published var emoji: String = ""

    private var cancellable = Set<AnyCancellable>()

    init() {
        CourseStorage.shared.courses.sink { courses in
            self.courses = courses
        }.store(in: &cancellable)
        ExamStorage.shared.exams.sink { exams in
            self.exams = exams
        }.store(in: &cancellable)
    }
}