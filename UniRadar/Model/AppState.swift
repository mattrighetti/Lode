//
//  AppState.swift
//  UniRadar
//
//  Created by Mattia Righetti on 03/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var accentColor: Color!
    @Published var firstAccess: Bool!
    @Published var initialSetup: Bool!
    
    init() {
        if UserDefaults.standard.object(forKey: "firstAccess") != nil {
            self.firstAccess = UserDefaults.standard.bool(forKey: "firstAccess")
        } else {
            self.firstAccess = true
        }
        
        if UserDefaults.standard.object(forKey: "initialSetup") != nil {
            self.initialSetup = UserDefaults.standard.bool(forKey: "initialSetup")
        } else {
            self.initialSetup = false
        }
        
        sub()
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private func sub() {
        self.$accentColor.sink(receiveValue: { value in
            UserDefaults.standard.set(value, forKey: "accentColor")
        }).store(in: &cancellables)
        
        self.$firstAccess.sink(receiveValue: { value in
            UserDefaults.standard.set(value, forKey: "firstAccess")
        }).store(in: &cancellables)
        
        self.$initialSetup.sink(receiveValue: { value in
            UserDefaults.standard.set(value, forKey: "initialSetup")
        }).store(in: &cancellables)
    }
    
}
