//
// Created by Mattia Righetti on 28/01/21.
//

import Combine
import Foundation

class ExamFormViewModel: ObservableObject {
    @Published var courseNotPassed: [Course] = []

    private var cancellable = Set<AnyCancellable>()

    init(coursePublisher: AnyPublisher<[Course], Never> = CourseStorage.shared.courses.eraseToAnyPublisher()) {
        coursePublisher.sink { [unowned self] in
            self.courseNotPassed = $0.filter({ $0.mark == 0 })
        }.store(in: &cancellable)
    }

    func addExam(withId id: UUID = UUID(), name: String, color: String, date: Date, course: Course) {
        ExamStorage.shared.add(id: id, name: name, color: color, date: date, course: course)
    }

    func update(withId id: UUID, name: String, color: String, date: Date, course: Course) {
        ExamStorage.shared.update(id: id, name: name, color: color, date: date, course: course)
    }

    func deleteExam(withId id: UUID) {
        ExamStorage.shared.delete(id: id)
    }
}
