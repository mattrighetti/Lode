//
// Created by Mattia Righetti on 26/01/21.
//

import Combine
import os

fileprivate var logger = Logger(subsystem: "com.mattrighetti.Lode", category: "CourseViewViewModel")

class CourseViewViewModel: ObservableObject {
    @Published var activeCourses: [Course] = []
    @Published var passedCourses: [Course] = []
    @Published var courses: [Course] = [] {
        willSet {
            logger.log("Updating courses to: \(newValue)")
            activeCourses = newValue.filter { $0.mark == 0 }
            passedCourses = newValue.filter { $0.mark != 0 }
        }
    }

    private var cancellable: AnyCancellable?

    init(coursePublisher: AnyPublisher<[Course], Never> = CourseStorage.shared.courses.eraseToAnyPublisher()) {
        cancellable = coursePublisher.sink { [unowned self] courses in
            logger.log("Updating courses")
            self.courses = courses
        }
    }
}
