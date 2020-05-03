//
//  Assignment.swift
//  UniRadar
//
//  Created by Mattia Righetti on 27/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Foundation
import CoreData

extension Assignment: Identifiable {
    var daysLeft: Int {
        if let date = dueDate {
            let calendar = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return calendar.day ?? -1
        }
        
        return -5
    }
}
