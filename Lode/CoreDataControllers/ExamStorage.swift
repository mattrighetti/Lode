//
// Created by Mattia Righetti on 24/01/21.
//

import Combine
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.mattrighetti.Lode", category: "ExamStorage")

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

    func add(id: UUID, name: String, color: String, date: Date) {
        let exam = Exam(context: PersistenceController.shared.container.viewContext)
        exam.setValue(id, forKey: "id")
        exam.setValue(name, forKey: "title")
        exam.setValue(color, forKey: "color")
        exam.setValue(date, forKey: "date")

        saveContext()
    }

    func update(id: UUID, name: String, color: String, date: Date) {
        let fetchExam: NSFetchRequest<Exam> = Exam.fetchRequest(withUUID: id)

        do {
            if let exam = try PersistenceController.shared.container.viewContext.fetch(fetchExam).first {
                exam.setValue(UUID(), forKey: "id")
                exam.setValue(name, forKey: "title")
                exam.setValue(color, forKey: "color")
                exam.setValue(date, forKey: "date")
            }

            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }

    func delete(id: UUID) {
        let fetchExam: NSFetchRequest<Exam> = Exam.fetchRequest(withUUID: id)

        do {
            logger.log("Deleting exam")
            guard let exam = try PersistenceController.shared.container.viewContext.fetch(fetchExam).first else { return }
            PersistenceController.shared.container.viewContext.delete(exam)
            saveContext()
            logger.log("Successfully deleted exam")
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

extension ExamStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let exams = controller.fetchedObjects as? [Exam] else { return }
        self.exams.value = exams
    }
}