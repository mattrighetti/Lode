//
//  +Utils.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import Foundation
import SwiftUI

extension Double {
    var twoDecimalPrecision: String {
        return String(format: "%.2f", self)
    }

    var noCommaPrecision: String {
        return String(format: "%.0f", self)
    }
}
