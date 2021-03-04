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
            caption: String = "No caption",
            dueDate: Date = Date(),
            title: String = "No title"
    ) {
        // CoreData stuff
        let entity = NSEntityDescription.entity(forEntityName: "Assignment", in: context)!
        self.init(entity: entity, insertInto: context)

        // ObjectData
        self.id = id
        self.caption = caption
        self.color = color.toHex!
        self.dueDate = dueDate
        self.title = title
    }

    var daysLeft: Int {
        guard let normalizedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: dueDate) else { fatalError() }
        guard let normalizedNow = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { fatalError() }
        let secondsDiff = normalizedDate - normalizedNow
        return Int(Int(secondsDiff / 60 / 60) / 24)
    }
    
    var completeDueDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: dueDate).capitalized
    }

}

extension Assignment {
    enum Request: RawRepresentable {
        case all
        case withUuid(uuid: UUID)
        
        typealias RawValue = NSFetchRequest<Assignment>
        
        init?(rawValue: NSFetchRequest<Assignment>) {
            return nil
        }
        
        var rawValue: NSFetchRequest<Assignment> {
            switch self {
            case .all:
                let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
                request.sortDescriptors = []
                return request
            case .withUuid(uuid: let uuid):
                let request: NSFetchRequest<Assignment> = Assignment.fetchRequest(withUUID: uuid)
                request.sortDescriptors = []
                return request
            }
        }
    }
}
