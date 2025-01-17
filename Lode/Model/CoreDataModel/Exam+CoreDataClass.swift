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
import SwiftUI

public class Exam: NSManagedObject {
    convenience init(
        context: NSManagedObjectContext,
        id: UUID = UUID(),
        color: Color,
        date: Date = Date(),
        title: String = "No title"
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Exam", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.color = color.toHex!
        self.date = date
        self.title = title
    }
    
    var daysLeft: Int {
        guard let normalizedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date) else { fatalError() }
        guard let normalizedNow = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { fatalError() }
        let secondsDiff = normalizedDate - normalizedNow
        return Int(Int(secondsDiff / 60 / 60) / 24)
    }

    var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date).capitalized
    }

    var completeDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: date).capitalized
    }

    var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date).capitalized
    }
    
    var dayInt: Int {
        Calendar.current.component(.day, from: date)
    }
    
}

extension Exam {
    enum Request: RawRepresentable {
        case all
        case withUuid(uuid: UUID)
        
        typealias RawValue = NSFetchRequest<Exam>
        
        init?(rawValue: NSFetchRequest<Exam>) {
            return nil
        }
        
        var rawValue: NSFetchRequest<Exam> {
            switch self {
            case .all:
                let request: NSFetchRequest<Exam> = Exam.fetchRequest()
                request.sortDescriptors = []
                return request
            case .withUuid(uuid: let uuid):
                let request: NSFetchRequest<Exam> = Exam.fetchRequest(withUUID: uuid)
                request.sortDescriptors = []
                return request
            }
        }
    }
}
