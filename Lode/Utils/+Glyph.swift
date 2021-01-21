//
//  +Glyph.swift
//  UniRadar
//
//  Created by Mattia Righetti on 27/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import Foundation

class Glyph {
    
    public static var glyphArray: [[String]] {
        return [
            ["sum", "function", "questionmark", "exclamationmark", "equal"],
            ["number", "x.squareroot", "arrow.2.circlepath", "dollarsign.circle", "exclamationmark.triangle"],
            ["suit.club", "suit.spade", "suit.diamond", "suit.heart", "star"]
        ]
    }
    
    public static func gridIndex(ofGlyph name: String) -> GridIndex? {
        for row in self.glyphArray.indices {
            if glyphArray[row].contains(name) {
                let col = glyphArray[row].firstIndex(of: name)!
                
                return GridIndex(row: row, column: col)
            }
        }
        
        return nil
    }
}
