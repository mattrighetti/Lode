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

    public class func fetchRequest() -> NSFetchRequest<Course> {
        NSFetchRequest<Course>(entityName: "Course")
    }
    
    public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Course> {
        let fetchCourse: NSFetchRequest<Course> = self.fetchRequest()
        fetchCourse.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        return fetchCourse
    }

    @NSManaged public var cfu: Int16
    @NSManaged public var color: String?
    @NSManaged public var expectedMark: Int16
    @NSManaged public var iconName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var laude: NSNumber?
    @NSManaged public var expectedLaude: NSNumber?
    @NSManaged public var mark: Int16
    @NSManaged public var name: String?

}
