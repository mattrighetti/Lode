//
// Created by Mattia Righetti on 28/01/21.
//

import Foundation
import Combine

class CourseFormViewModel {
    func addCourse(withId id: UUID? = UUID(), name: String, cfu: Int, color: String, expectedMark: Int, iconName: String, laude: Bool?, expectedLaude: Bool, mark: Int?) {
        CourseStorage.shared.add(withId: id!, name: name, cfu: cfu, color: color, expectedMark: expectedMark, iconName: iconName, laude: laude, expectedLaude: expectedLaude, mark: mark)
    }

    func update(withId id: UUID, name: String, cfu: Int, color: String, expectedMark: Int, iconName: String, laude: Bool?, expectedLaude: Bool, mark: Int?) {
        CourseStorage.shared.update(withId: id, name: name, cfu: cfu, color: color, expectedMark: expectedMark, iconName: iconName, laude: laude, expectedLaude: expectedLaude, mark: mark)
    }

    func deleteCourse(withId id: UUID) {
        CourseStorage.shared.delete(id: id)
    }
}
