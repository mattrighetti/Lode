//
// Created by Mattia Righetti on 26/01/21.
//

import Combine

class CourseViewViewModel: ObservableObject {
    @Published var activeCourses: [Course] = []
    @Published var passedCourses: [Course] = []
    @Published var courses: [Course] = [] {
        willSet {
            activeCourses = newValue.filter { $0.mark == 0 }
            passedCourses = newValue.filter { $0.mark != 0 }
        }
    }
    private var cancellable: AnyCancellable?

    init() {
        cancellable = CourseStorage.shared.courses.sink { courses in
            self.courses = courses
        }
    }
}