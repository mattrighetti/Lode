//
// Created by Mattia Righetti on 27/01/21.
//

import Combine
import Foundation

class ExamViewViewModel: ObservableObject {
    @Published var selectedExam: Exam?
    @Published var courseNotPassedStrings: [String] = []
    @Published var upcomingExams: [Exam] = []
    @Published var pastExams: [Exam] = []
    @Published var exams: [Exam] = [] {
        willSet {
            upcomingExams = newValue.filter { $0.date! > Date() }
            pastExams = newValue.filter { $0.date! <= Date() }
        }
    }

    private var cancellable = Set<AnyCancellable>()

    init() {
        CourseStorage.shared.courses.sink {
            self.courseNotPassedStrings = $0.filter({ $0.mark == 0 }).map { $0.name! }
        }.store(in: &cancellable)
        ExamStorage.shared.exams.sink {
            self.exams = $0.sorted(by: { $0.date! < $1.date! })
        }.store(in: &cancellable)
    }
}