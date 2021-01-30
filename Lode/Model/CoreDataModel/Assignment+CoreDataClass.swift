//
//  Assignment+CoreDataClass.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

public class Assignment: NSManagedObject {

    convenience init(
            context: NSManagedObjectContext,
            id: UUID = UUID(),
            color: Color,
            caption: String? = "No caption",
            dueDate: Date? = Date(),
            title: String? = "No title"
    ) {
        // CoreData stuff
        let entity = NSEntityDescription.entity(forEntityName: "Assignment", in: context)!
        self.init(entity: entity, insertInto: context)
        
        // ObjectData
        self.id = id
        self.caption = caption
        self.color = color.toHex
        self.dueDate = dueDate
        self.title = title
    }
    
    var daysLeft: Int {
        if let date = dueDate {
            let calendar = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return calendar.day ?? -1
        }
        
        return -5
    }
    
    var completeDueDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: dueDate!).capitalized
    }
    
}

extension Assignment {
    static var requestAll: NSFetchRequest<Assignment> {
        let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}
