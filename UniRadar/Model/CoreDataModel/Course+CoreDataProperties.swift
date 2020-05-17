//
//  Course+CoreDataProperties.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//
//

import Foundation
import CoreData

extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }
    
    @nonobjc public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Course> {
        let fetchCourse: NSFetchRequest<Course> = self.fetchRequest()
        fetchCourse.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        return fetchCourse
    }

    @NSManaged public var cfu: Int16
    @NSManaged public var colorColIndex: Int16
    @NSManaged public var colorRowIndex: Int16
    @NSManaged public var expectedMark: Int16
    @NSManaged public var iconName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var mark: Int16
    @NSManaged public var name: String?

}
