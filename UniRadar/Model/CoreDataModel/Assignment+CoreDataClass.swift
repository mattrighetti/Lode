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

public class Assignment: NSManagedObject {
    var daysLeft: Int {
        if let date = dueDate {
            let calendar = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return calendar.day ?? -1
        }
        
        return -5
    }
}
