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
            gainedCfu = newValue
                .filter { $0.mark != 0 }
                .map { Double($0.cfu) }
                .reduce(0, { $0 + $1 })
            
            if gainedCfu == 0.0 {
                average = 0.0
            } else {
                average = newValue
                    .filter { $0.mark != 0 }
                    .map { Double($0.cfu) * Double($0.mark) }
                    .reduce(0, { $0 + $1 }) / gainedCfu
            }
        }
    }
    @Published var upcomingExams: Int = 0
    @Published var gainedCfu: Double = 0.0
    @Published var average: Double = 0.0
    @Published var dueAssignments: Int = 0

    private var cancellable = Set<AnyCancellable>()

    init(
        coursePublisher: AnyPublisher<[Course], Never> = CourseStorage.shared.courses.eraseToAnyPublisher(),
        examPublisher: AnyPublisher<[Exam], Never> = ExamStorage.shared.exams.eraseToAnyPublisher(),
        assignmentPublisher: AnyPublisher<[Assignment], Never> = AssignmentStorage.shared.assignments.eraseToAnyPublisher()
    ) {
        coursePublisher.sink { [unowned self] courses in
            self.courses = courses
        }.store(in: &cancellable)
        examPublisher.sink { [unowned self] exams in
            self.upcomingExams = exams.filter { $0.date > Date() }.count
        }.store(in: &cancellable)
        assignmentPublisher.sink { [unowned self] assignments in
            self.dueAssignments = assignments.count
        }.store(in: &cancellable)
    }
}
