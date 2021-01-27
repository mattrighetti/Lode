//
// Created by Mattia Righetti on 24/01/21.
//

import Combine
import CoreData

class AssignmentStorage: NSObject {
    var assignments = CurrentValueSubject<[Assignment], Never>([])
    private var assignmentFetchController: NSFetchedResultsController<Assignment>
    static let shared: AssignmentStorage = AssignmentStorage()

    private override init() {
        assignmentFetchController = NSFetchedResultsController(
                fetchRequest: Assignment.requestAll,
                managedObjectContext: PersistenceController.shared.container.viewContext,
                sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        assignmentFetchController.delegate = self

        do {
            try assignmentFetchController.performFetch()
            assignments.value = assignmentFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects")
        }
    }
}

extension AssignmentStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let assignments = controller.fetchedObjects as? [Assignment] else { return }
        self.assignments.value = assignments
    }
}