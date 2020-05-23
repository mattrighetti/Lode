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
    @Published var tintColor: UIColor!
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
        
        if UserDefaults.standard.object(forKey: "tintColor") != nil {
            self.tintColor = UserDefaults.standard.color(forKey: "tintColor")
        } else {
            self.tintColor = .red
        }
        
        sub()
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private func sub() {
        self.$tintColor.sink(receiveValue: { value in
            UserDefaults.standard.set(value, forKey: "tintColor")
        }).store(in: &cancellables)
        
        self.$firstAccess.sink(receiveValue: { value in
            UserDefaults.standard.set(value, forKey: "firstAccess")
        }).store(in: &cancellables)
        
        self.$initialSetup.sink(receiveValue: { value in
            UserDefaults.standard.set(value, forKey: "initialSetup")
        }).store(in: &cancellables)
    }
    
}

extension UserDefaults {

    func color(forKey key: String) -> UIColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }

    }

}
