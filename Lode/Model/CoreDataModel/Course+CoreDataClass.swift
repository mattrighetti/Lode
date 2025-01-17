//
//  Course+CoreDataClass.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

public class Course: NSManagedObject {
    convenience init(
        context: NSManagedObjectContext,
        id: UUID = UUID(),
        cfu: Int,
        color: Color,
        expectedMark: Int,
        iconName: String = "No icon",
        laude: Bool?,
        expectedLaude: Bool?,
        mark: Int?,
        name: String = "No name"
    ) {
            // CoreData stuff
            let entity = NSEntityDescription.entity(forEntityName: "Course", in: context)!
            self.init(entity: entity, insertInto: context)
            // Object data
            self.id = id
            self.cfu = Int16(cfu)
            self.color = color.toHex!
            self.expectedMark = Int16(expectedMark)
            self.iconName = iconName
            self.laude = NSNumber(value: (expectedMark == 31))
            self.expectedLaude = NSNumber(value: (expectedMark == 31))
            self.mark = Int16(mark ?? 0)
            self.name = name
    }
    
    convenience init(
        context: NSManagedObjectContext,
        id: UUID = UUID(),
        cfu: Int,
        color: Color,
        expectedMark: Int
    ) {
        self.init(
            context: context,
            cfu: cfu,
            color: color,
            expectedMark: expectedMark,
            iconName: "No icon",
            laude: nil,
            expectedLaude: nil,
            mark: nil,
            name: "No name"
        )
    }
}

// MARK : - REQUESTS

extension Course {
    enum Request: RawRepresentable {
        case all
        case notPassed
        case withMark(mark: Int)
        case withUuid(uuid: UUID)
        
        typealias RawValue = NSFetchRequest<Course>
        
        init?(rawValue: NSFetchRequest<Course>) {
            return nil
        }
        
        var rawValue: NSFetchRequest<Course> {
            switch self {
            case .all:
                let request: NSFetchRequest<Course> = Course.fetchRequest()
                request.sortDescriptors = []
                return request
            case .notPassed:
                let request: NSFetchRequest<Course> = Course.fetchNotPassedCourses()
                request.sortDescriptors = []
                return request
            case .withMark(mark: let mark):
                let request: NSFetchRequest<Course> = Course.fetchPassedCourses(withMark: mark)
                request.sortDescriptors = []
                return request
            case .withUuid(uuid: let uuid):
                let request: NSFetchRequest<Course> = Course.fetchRequest(withUUID: uuid)
                request.sortDescriptors = []
                return request
            }
        }
    }
}
