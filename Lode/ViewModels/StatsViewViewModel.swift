//
// Created by Mattia Righetti on 27/01/21.
//

import Foundation
import Combine

class StatsViewViewModel: ObservableObject {
    @Published var courses: [Course] = [] {
        willSet {
            totalCourses = Double(newValue.count)
            totalCfu = newValue.compactMap { course in Double(course.cfu) }.reduce(0, { $0 + $1 })
            let markSum = newValue.compactMap { Double($0.expectedMark) * Double($0.cfu) }.reduce(0, { $0 + $1 })
            if totalCfu != 0 {
                expectedAverage = markSum / Double(totalCfu)
                projectedGraduationGrade = expectedAverage * 110.0 / 30.0
            }
            passedExams = newValue.filter { $0.mark != 0 }
            numPassedExams = Double(passedExams.count)
            gainedCfu = passedExams.compactMap { Double($0.cfu) }.reduce(0, { $0 + $1 })
            let average = passedExams.compactMap { Double($0.cfu) * Double($0.mark) }.reduce(0, { $0 + $1 })
            if gainedCfu != 0 {
                currentAverage = average / gainedCfu
                currentProjectedGraduationGrade = currentAverage * 110.0 / 30.0
            }
            asExpected = Double(passedExams.filter { $0.mark == $0.expectedMark }.count)
            betterThanExpected = Double(passedExams.filter { $0.mark > $0.expectedMark }.count)
            worseThanExpected = Double(passedExams.filter { $0.mark < $0.expectedMark }.count)
            passedExams.sorted(by: { $0.mark < $1.mark }).forEach {
                pieChartPassedCoursesMarks[Int($0.mark)] = (pieChartPassedCoursesMarks[Int($0.mark)] ?? 0) + 1
            }
        }
    }
    @Published var totalCourses: Double = 0.0
    @Published var totalCfu: Double = 0.0
    @Published var expectedAverage: Double = 0.0
    @Published var projectedGraduationGrade: Double = 0.0
    @Published var passedExams: [Course] = []
    @Published var numPassedExams: Double = 0.0
    @Published var gainedCfu: Double = 0.0
    @Published var currentAverage: Double = 0.0
    @Published var currentProjectedGraduationGrade: Double = 0.0
    @Published var asExpected: Double = 0.0
    @Published var betterThanExpected: Double = 0.0
    @Published var worseThanExpected: Double = 0.0
    @Published var pieChartPassedCoursesMarks: [Int:Int] = [:]

    private var cancellables: Set<AnyCancellable>

    init() {
        cancellables = Set<AnyCancellable>()
        CourseStorage.shared.courses.sink { [unowned self] courses in
            self.courses = courses
        }.store(in: &cancellables)
    }
}
