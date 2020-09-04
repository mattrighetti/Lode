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

public class Course: NSManagedObject {
    convenience init(
        context: NSManagedObjectContext!,
        id: UUID = UUID(),
        cfu: Int,
        colorColIndex: Int,
        colorRowIndex: Int,
        expectedMark: Int,
        iconName: String? = "No icon",
        laude: Bool?,
        expectedLaude: Bool?,
        mark: Int?,
        name: String? = "No name") {
            // CoreData stuff
            let entity = NSEntityDescription.entity(forEntityName: "Course", in: context)!
            self.init(entity: entity, insertInto: context)
            // Object data
            self.id = id
            self.cfu = Int16(cfu)
            self.colorColIndex = Int16(colorColIndex)
            self.colorRowIndex = Int16(colorRowIndex)
            self.expectedMark = Int16(expectedMark)
            self.iconName = iconName
            self.laude = NSNumber(value: (expectedMark == 31))
            self.expectedLaude = NSNumber(value: (expectedMark == 31))
            self.mark = Int16(mark ?? 0)
            self.name = name
    }
    
    convenience init(
        context: NSManagedObjectContext!,
        id: UUID = UUID(),
        cfu: Int,
        colorColIndex: Int,
        colorRowIndex: Int,
        expectedMark: Int) {
        
        self.init(context: context,
                  cfu: cfu,
                  colorColIndex: colorColIndex,
                  colorRowIndex: colorRowIndex,
                  expectedMark: expectedMark,
                  iconName: nil,
                  laude: nil,
                  expectedLaude: nil,
                  mark: nil,
                  name: nil
        )
        
    }
}
