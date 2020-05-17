//
//  ViewModelTest.swift
//  UniRadarTests
//
//  Created by Mattia Righetti on 16/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import XCTest
@testable import UniRadar

class ViewModelTest: XCTestCase {
    var viewModel: ViewModel!
    
    override func setUp() {
        super.setUp()
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        viewModel = ViewModel(context: context!)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testCalculateAverage() {
        let courses: [Course] = [
            
        ]
    }
    
}
