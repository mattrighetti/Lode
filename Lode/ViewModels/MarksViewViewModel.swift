//
// Created by Mattia Righetti on 27/01/21.
//

import Foundation
import Combine

class MarksViewViewModel: ObservableObject {
    @Published var courses: [Course] = []
    private var cancellable: AnyCancellable?

    init(coursePublisher: AnyPublisher<[Course], Never> = CourseStorage.shared.courses.eraseToAnyPublisher()) {
        cancellable = coursePublisher.sink { [unowned self] courses in
            self.courses = courses
        }
    }
}