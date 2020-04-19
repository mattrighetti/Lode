//
//  Mark.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Foundation

struct Mark: Identifiable {
    let id = UUID()
    var subjectName: String
    var expectedMark: Int
    var finalMark: Int?
    var difficulty: Int
    var datePassedString: String = "No date"
    var datePassed: Date
    
    init(subjectName: String, expectedMark: Int, difficulty: Int, datePassed: Date) {
        self.subjectName = subjectName
        self.expectedMark = expectedMark
        self.finalMark = nil
        self.difficulty = difficulty
        self.datePassed = datePassed
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        datePassedString = dateFormatter.string(from: datePassed)
    }
    
    init(subjectName: String, expectedMark: Int, finalMark: Int, difficulty: Int, datePassed: Date) {
        self.subjectName = subjectName
        self.expectedMark = expectedMark
        self.finalMark = finalMark
        self.difficulty = difficulty
        self.datePassed = datePassed
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        datePassedString = dateFormatter.string(from: datePassed)
    }
    
}
