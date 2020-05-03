//
//  AppState.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var accentColor: Color = .blue
    @Published var firstAccess: Bool = true
}
