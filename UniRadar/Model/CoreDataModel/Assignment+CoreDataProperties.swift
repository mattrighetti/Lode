//
//  Assignment+CoreDataProperties.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//
//

import Foundation
import CoreData

extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var caption: String?
    @NSManaged public var colorColumnIndex: Int16
    @NSManaged public var colorRowIndex: Int16
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}
