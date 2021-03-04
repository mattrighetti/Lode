//
// Created by Mattia Righetti on 27/01/21.
//

import Combine
import Foundation

class AssignmentViewViewModel: ObservableObject {
    @Published var assignments: [Assignment] = [] {
        willSet {
            dueAssignments = newValue.filter { $0.daysLeft >= 0 }
            pastAssignments = newValue.filter { $0.daysLeft <= 0 }
        }
    }
    @Published var dueAssignments: [Assignment] = []
    @Published var pastAssignments: [Assignment] = []
    private var cancellable: AnyCancellable?

    init() {
        cancellable = AssignmentStorage.shared.assignments.sink { [unowned self] assignments in
            self.assignments = assignments.sorted(by: { $0.dueDate < $1.dueDate })
        }
    }
}
