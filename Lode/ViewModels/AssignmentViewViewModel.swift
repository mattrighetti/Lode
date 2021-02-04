//
// Created by Mattia Righetti on 27/01/21.
//

import Combine
import Foundation

class AssignmentViewViewModel: ObservableObject {
    @Published var assignments: [Assignment] = [] {
        willSet {
            dueAssignments = newValue.filter { $0.dueDate! > Date() }
            pastAssignments = newValue.filter { $0.dueDate! <= Date() }
        }
    }
    @Published var dueAssignments: [Assignment] = []
    @Published var pastAssignments: [Assignment] = []
    private var cancellable: AnyCancellable?

    init() {
        cancellable = AssignmentStorage.shared.assignments.sink { [unowned self] assignments in
            self.assignments = assignments
        }
    }
}