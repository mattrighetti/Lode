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

    public class func fetchRequest() -> NSFetchRequest<Exam> {
        NSFetchRequest<Exam>(entityName: "Exam")
    }
    
    public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Exam> {
        let fetchExam: NSFetchRequest<Exam> = self.fetchRequest()
        fetchExam.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        return fetchExam
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}
