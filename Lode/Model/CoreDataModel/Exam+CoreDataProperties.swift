//
//  Exam+CoreDataProperties.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//
//

import Foundation
import CoreData

extension Exam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exam> {
        return NSFetchRequest<Exam>(entityName: "Exam")
    }
    
    @nonobjc public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Exam> {
        let fetchExam: NSFetchRequest<Exam> = self.fetchRequest()
        fetchExam.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        return fetchExam
    }

    @NSManaged public var colorColIndex: Int16
    @NSManaged public var colorRowIndex: Int16
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}
