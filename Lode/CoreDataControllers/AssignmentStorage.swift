//
// Created by Mattia Righetti on 24/01/21.
//

import Combine
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.mattrighetti.Lode", category: "AssignmentStorage")

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

    func add(withId id: UUID, title: String, caption: String, color: String, dueDate: Date) {
        let newAssignment = Assignment(context: PersistenceController.shared.container.viewContext)
        newAssignment.setValue(id, forKey: "id")
        newAssignment.setValue(title, forKey: "title")
        newAssignment.setValue(caption, forKey: "caption")
        newAssignment.setValue(color, forKey: "color")
        newAssignment.setValue(dueDate, forKey: "dueDate")

        saveContext()
    }

    func update(withId id: UUID, title: String, caption: String, color: String, dueDate: Date) {
        let fetchAssignment: NSFetchRequest<Assignment> = Assignment.fetchRequest(withUUID: id)

        do {
            if let assignment = try PersistenceController.shared.container.viewContext.fetch(fetchAssignment).first {
                assignment.setValue(title, forKey: "title")
                assignment.setValue(caption, forKey: "caption")
                assignment.setValue(color, forKey: "color")
                assignment.setValue(dueDate, forKey: "dueDate")
            }

            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }

    func delete(id: UUID) {
        let fetchAssignment: NSFetchRequest<Assignment> = Assignment.fetchRequest(withUUID: id)

        do {
            logger.log("Deleting assignment")
            guard let exam = try PersistenceController.shared.container.viewContext.fetch(fetchAssignment).first else { return }
            PersistenceController.shared.container.viewContext.delete(exam)
            saveContext()
            logger.log("Successfully deleted assignment")
        } catch {
            debugPrint(error)
        }
    }

    private func saveContext() {
        do {
            logger.log("Saving context")
            try PersistenceController.shared.container.viewContext.save()
            logger.log("Successfully saved context")
        } catch {
            logger.error("ERROR: \(error as NSObject)")
        }
    }
}

extension AssignmentStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let assignments = controller.fetchedObjects as? [Assignment] else { return }
        self.assignments.value = assignments
    }
}