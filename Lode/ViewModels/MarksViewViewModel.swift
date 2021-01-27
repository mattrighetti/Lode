//
// Created by Mattia Righetti on 27/01/21.
//

import Foundation
import Combine

class MarksViewViewModel: ObservableObject {
    @Published var courses: [Course] = []
    private var cancellable: AnyCancellable?

    init() {
        cancellable = CourseStorage.shared.courses.sink { courses in
            self.courses = courses
        }
    }
}