//
//  +Utils.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import Foundation
import SwiftUI

struct Constants {
    static let iconMinWidth: CGFloat = 36
    static let sfSymbolSize: CGFloat = 22
    static let navBarIcons: CGFloat = 24
    static let pickerMaxWidth: CGFloat = 256
}

extension Double {
    var twoDecimalPrecision: String {
        return String(format: "%.2f", self)
    }
    
    var noCommaPrecision: String {
        return String(format: "%.0f", self)
    }
}

extension Image {
    func iconModifier() -> some View {
        self
            .font(.system(size: Constants.sfSymbolSize))
            .frame(minWidth: Constants.iconMinWidth)
            .accessibility(hidden: true)
    }
}
