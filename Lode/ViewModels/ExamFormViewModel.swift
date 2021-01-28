//
// Created by Mattia Righetti on 28/01/21.
//

import Combine
import Foundation

class ExamFormViewModel: ObservableObject {
    @Published var courseNotPassedStrings: [String] = []

    private var cancellable = Set<AnyCancellable>()

    init() {
        CourseStorage.shared.courses.sink {
            self.courseNotPassedStrings = $0.filter({ $0.mark == 0 }).map { $0.name! }
        }.store(in: &cancellable)
    }

    func addExam(withId id: UUID = UUID(), name: String, color: String, date: Date) {
        ExamStorage.shared.add(id: id, name: name, color: color, date: date)
    }

    func update(withId id: UUID, name: String, color: String, date: Date) {
        ExamStorage.shared.update(id: id, name: name, color: color, date: date)
    }

    func deleteExam(withId id: UUID) {
        ExamStorage.shared.delete(id: id)
    }
}