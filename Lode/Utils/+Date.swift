//
//  +Date.swift
//  Lode
//
//  Created by Mattia Righetti on 04/03/21.
//

import Foundation

extension Date {
    static func -(lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
