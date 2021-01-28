//
// Created by Mattia Righetti on 24/01/21.
//

import Combine
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.mattrighetti.Lode", category: "CourseStorage")

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

    func add(withId id: UUID, name: String, cfu: Int, color: String, expectedMark: Int, iconName: String, laude: Bool?, expectedLaude: Bool, mark: Int?) {
        let newCourse = Course(context: PersistenceController.shared.container.viewContext)
        newCourse.setValue(id, forKey: "id")
        newCourse.setValue(Int16(cfu), forKey: "cfu")
        newCourse.setValue(color, forKey: "color")
        newCourse.setValue(Int16(expectedMark), forKey: "expectedMark")
        newCourse.setValue(iconName, forKey: "iconName")
        newCourse.setValue(NSNumber(booleanLiteral: laude ?? false), forKey: "laude")
        newCourse.setValue(NSNumber(booleanLiteral: expectedLaude), forKey: "expectedLaude")
        newCourse.setValue(Int16(mark ?? 0), forKey: "mark")
        newCourse.setValue(name, forKey: "name")

        saveContext()
    }

    func update(withId id: UUID, name: String, cfu: Int, color: String, expectedMark: Int, iconName: String, laude: Bool?, expectedLaude: Bool, mark: Int?) {
        let fetchCourse: NSFetchRequest<Course> = Course.fetchRequest(withUUID: id)

        do {
            if let course = try PersistenceController.shared.container.viewContext.fetch(fetchCourse).first {
                course.setValue(Int16(cfu), forKey: "cfu")
                course.setValue(color, forKey: "color")
                course.setValue(Int16(expectedMark), forKey: "expectedMark")
                course.setValue(iconName, forKey: "iconName")
                course.setValue(NSNumber(booleanLiteral: laude ?? false), forKey: "laude")
                course.setValue(NSNumber(booleanLiteral: expectedLaude), forKey: "expectedLaude")
                course.setValue(Int16(mark ?? 0), forKey: "mark")
                course.setValue(name, forKey: "name")
            }

            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }

    func delete(id: UUID) {
        let fetchExam: NSFetchRequest<Course> = Course.fetchRequest(withUUID: id)

        do {
            logger.log("Deleting course")
            guard let exam = try PersistenceController.shared.container.viewContext.fetch(fetchExam).first else { return }
            PersistenceController.shared.container.viewContext.delete(exam)
            saveContext()
            logger.log("Successfully deleted course")
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

extension CourseStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let courses = controller.fetchedObjects as? [Course] else { return }
        logger.log("Context has changed, reloading courses")
        self.courses.value = courses
    }
}
