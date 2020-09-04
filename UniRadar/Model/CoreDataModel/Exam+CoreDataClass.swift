//
//  Exam+CoreDataClass.swift
//  UniRadar
//
//  Created by Mattia Righetti on 08/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//
//

import Foundation
import CoreData

public class Exam: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext,
                     id: UUID = UUID(),
                     colorColIndex: Int,
                     colorRowIndex: Int,
                     date: Date? = Date(),
                     title: String? = "No title") {
        let entity = NSEntityDescription.entity(forEntityName: "Exam", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.colorColIndex = Int16(colorColIndex)
        self.colorRowIndex = Int16(colorRowIndex)
        self.date = date
        self.title = title
    }
    
    var daysLeft: Int {
        if let date = date {
            let calendar = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return calendar.day ?? -1
        }
        
        return -5
    }
    
    var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date!).capitalized
    }
    
    var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date!).capitalized
    }
    
    var dayInt: Int {
        return Calendar.current.component(.day, from: date!)
    }
    
}
