//
// Created by Mattia Righetti on 24/01/21.
//

import Combine
import CoreData

class ExamStorage: NSObject, ObservableObject {
    var exams = CurrentValueSubject<[Exam], Never>([])
    private var examFetchController: NSFetchedResultsController<Exam>
    static let shared: ExamStorage = ExamStorage()

    private override init() {
        examFetchController = NSFetchedResultsController(
                fetchRequest: Exam.requestAll,
                managedObjectContext: PersistenceController.shared.container.viewContext,
                sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        examFetchController.delegate = self

        do {
            try examFetchController.performFetch()
            exams.value = examFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects")
        }
    }
}

extension ExamStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let exams = controller.fetchedObjects as? [Exam] else { return }
        self.exams.value = exams
    }
}