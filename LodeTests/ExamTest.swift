//
//  ExamTest.swift
//  LodeTests
//
//  Created by Mattia Righetti on 03/03/21.
//

import XCTest
import CoreData
@testable import Lode

class ExamTest: XCTestCase {
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Lode")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    func testExamDaysLeft() {
        let date1 = DateComponents(calendar: .current, timeZone: .current, year: 2021, month: 3, day: 4, hour: 0).date!
        let date2 = DateComponents(calendar: .current, timeZone: .current, year: 2021, month: 3, day: 5, hour: 5).date!
        let date3 = DateComponents(calendar: .current, timeZone: .current, year: 2021, month: 3, day: 6, hour: 6).date!
        let date4 = DateComponents(calendar: .current, timeZone: .current, year: 2021, month: 3, day: 3, hour: 6).date!
        let exam1 = Exam(context: mockPersistantContainer.viewContext, id: UUID(), color: .flatRed, date: date1, title: "Title")
        let exam2 = Exam(context: mockPersistantContainer.viewContext, id: UUID(), color: .flatRed, date: date2, title: "Title")
        let exam3 = Exam(context: mockPersistantContainer.viewContext, id: UUID(), color: .flatRed, date: date3, title: "Title")
        let exam4 = Exam(context: mockPersistantContainer.viewContext, id: UUID(), color: .flatRed, date: date4, title: "Title")
        
        XCTAssertEqual(exam1.daysLeft, 0)
        XCTAssertEqual(exam2.daysLeft, 1)
        XCTAssertEqual(exam3.daysLeft, 2)
        XCTAssertEqual(exam4.daysLeft, -1)
    }

}
