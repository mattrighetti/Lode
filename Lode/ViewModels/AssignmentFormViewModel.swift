//
// Created by Mattia Righetti on 28/01/21.
//

import Foundation
import Combine

class AssignmentFormViewModel {
    func addAssignment(withId id: UUID = UUID(), title: String, caption: String, color: String, dueDate: Date) {
        AssignmentStorage.shared.add(withId: id, title: title, caption: caption, color: color, dueDate: dueDate)
    }

    func update(withId id: UUID, title: String, caption: String, color: String, dueDate: Date) {
        AssignmentStorage.shared.update(withId: id, title: title, caption: caption, color: color, dueDate: dueDate)
    }

    func delete(id: UUID) {
        AssignmentStorage.shared.delete(id: id)
    }
}