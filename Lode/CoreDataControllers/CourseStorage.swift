//
// Created by Mattia Righetti on 24/01/21.
//

import Combine
import CoreData

class CourseStorage: NSObject, ObservableObject {
    var courses = CurrentValueSubject<[Course], Never>([])
    private let courseFetchController: NSFetchedResultsController<Course>
    static let shared: CourseStorage = CourseStorage()

    private override init() {
        courseFetchController = NSFetchedResultsController(
                fetchRequest: Course.requestAll,
                managedObjectContext: PersistenceController.shared.container.viewContext,
                sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        courseFetchController.delegate = self

        do {
            try courseFetchController.performFetch()
            courses.value = courseFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects")
        }
    }
}

extension CourseStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let courses = controller.fetchedObjects as? [Course] else { return }
        self.courses.value = courses
    }
}