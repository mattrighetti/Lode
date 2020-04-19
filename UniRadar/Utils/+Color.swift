//
//  +Color.swift
//  UniRadar
//
//  Created by Mattia Righetti on 05/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

extension Color {
    public static let flatBlack: Color = Color(red: 28/255, green: 28/255, blue: 29/255)
    public static let flatLightRed: Color = Color(red: 215/255, green: 51/255, blue: 88/255)
    public static let flatDarkRed: Color = Color(red: 207/255, green: 23/255, blue: 47/255)
    public static let flatLightGray: Color = Color(red: 241/255, green: 243/255, blue: 244/255)
    public static let flatDarkGray: Color = Color(red: 36/255, green: 36/255, blue: 36/255)
    public static let flatDarkBlue: Color = Color(red: 47/255, green: 54/255, blue: 78/255)
    public static var outlineRed: Color {
        return Color(decimalRed: 34, green: 0, blue: 3)
    }
    
    public static var darkRed: Color {
        return Color(decimalRed: 221, green: 31, blue: 59)
    }
    
    public static var lightRed: Color {
        return Color(decimalRed: 239, green: 54, blue: 128)
    }
    
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}
