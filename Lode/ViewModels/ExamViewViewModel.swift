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
            upcomingExams = newValue.filter { $0.date > Date() }
            pastExams = newValue.filter { $0.date <= Date() }
        }
    }

    private var cancellable = Set<AnyCancellable>()

    init(
        coursePublisher: AnyPublisher<[Course], Never> = CourseStorage.shared.courses.eraseToAnyPublisher(),
        examPublisher: AnyPublisher<[Exam], Never> = ExamStorage.shared.exams.eraseToAnyPublisher()
    ) {
        coursePublisher.sink { [unowned self] in
            self.courseNotPassedStrings = $0.filter({ $0.mark == 0 }).map { $0.name }
        }.store(in: &cancellable)
        examPublisher.sink { [unowned self] in
            self.exams = $0.sorted(by: { $0.date < $1.date })
        }.store(in: &cancellable)
    }
}
