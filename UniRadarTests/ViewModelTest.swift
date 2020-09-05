//
//  ViewModelTest.swift
//  UniRadarTests
//
//  Created by Mattia Righetti on 16/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import XCTest
import Combine
@testable import Lode

class ViewModelTest: XCTestCase {
    var viewModel: ViewModel!
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func setUp() {
        super.setUp()
        self.viewModel = ViewModel(context: context!)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testCalculateAverage() {
        let expectedValue = 0.0
        
        _ = viewModel.$average
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue:  { value in
                XCTAssertNotNil(value)
                XCTAssertTrue(value == expectedValue)
            })
    }
    
    func testCalculateExpectedAverageWithMarks() {
        var countValuesReceived = 0
        var countValuesSent = 0
        let expectedValues = [0.0, 30.0, 30.0, 30.0, 28.25, 25.83333333, 23.88095238]
        
        let expectation = XCTestExpectation(description: "Adding course to viewModel.courses")
        
        XCTAssertEqual(countValuesReceived, 0)
        XCTAssertEqual(viewModel.average, expectedValues[countValuesReceived])
        XCTAssertEqual(viewModel.expectedAverage, expectedValues[countValuesReceived])
        
        let subscription = self.viewModel.$courses
            .sink(receiveValue: { course in
                XCTAssertNotNil(course)
                XCTAssertEqual(course.count, countValuesReceived)
                XCTAssertEqual(self.viewModel.expectedAverage.twoDecimalPrecision, expectedValues[countValuesReceived].twoDecimalPrecision)
                
                expectation.fulfill()
                countValuesReceived += 1
            })
        countValuesSent += 1
        
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 23))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 10, colorColIndex: 0, colorRowIndex: 0, expectedMark: 21))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 12, colorColIndex: 0, colorRowIndex: 0, expectedMark: 19))
        countValuesSent += 1
        
        XCTAssertEqual(countValuesReceived, countValuesSent)
        
        addTeardownBlock {
            subscription.cancel()
            self.viewModel.courses.removeAll()
        }
    }
    
    func testCalculateAverageWithMarks() {
        var countValuesReceived = 0
        var countValuesSent = 0
        let expectedValues = [0.0, 30.0, 30.0, 30.0, 28.25, 25.83333333, 23.88095238]
        let expectedProjectedGraduationGrade = [0.0, 110.0, 110.0, 110.0, 103.583333, 94.722221, 87.56349]
        let expectedGainedCfu = [0, 5, 10, 15, 20, 30, 42]
        
        let expectation = XCTestExpectation(description: "Adding course to viewModel.courses")
        
        XCTAssertEqual(countValuesReceived, 0)
        XCTAssertEqual(viewModel.average, expectedValues[countValuesReceived])
        XCTAssertEqual(viewModel.expectedAverage, expectedValues[countValuesReceived])
        
        let subscription = self.viewModel.$courses
            .sink(receiveValue: { course in
                XCTAssertNotNil(course)
                XCTAssertEqual(course.count, countValuesReceived)
                XCTAssertEqual(self.viewModel.average.twoDecimalPrecision, expectedValues[countValuesReceived].twoDecimalPrecision)
                XCTAssertEqual(self.viewModel.gainedCfu, expectedGainedCfu[countValuesReceived])
                XCTAssertEqual(self.viewModel.projectedGraduationGrade.twoDecimalPrecision, expectedProjectedGraduationGrade[countValuesReceived].twoDecimalPrecision)
                
                expectation.fulfill()
                countValuesReceived += 1
            })
        countValuesSent += 1
        
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 23, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 10, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 21, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 12, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 19, name: nil))
        countValuesSent += 1
        
        XCTAssertEqual(countValuesReceived, countValuesSent)
        
        addTeardownBlock {
            subscription.cancel()
            self.viewModel.courses.removeAll()
        }
    }
    
    func testCalculateProjectedGraduationGrade() {
        var countValuesReceived = 0
        var countValuesSent = 0
        let expectedProjectedGraduationGrade = [0.0, 110.0, 110.0, 110.0, 103.583333, 94.722221, 87.56349]
        let expectedEProjectedGraduationGrade = [0.0, 110.0, 110.0, 110.0, 110.0, 110.0, 110.0]
        
        XCTAssertEqual(countValuesReceived, 0)
        XCTAssertEqual(viewModel.average, 0.0)
        XCTAssertEqual(viewModel.expectedAverage, 0.0)
        
        let subscription = self.viewModel.$courses
            .sink(receiveValue: { course in
                XCTAssertNotNil(course)
                XCTAssertEqual(course.count, countValuesReceived)
                XCTAssertEqual(self.viewModel.projectedGraduationGrade.twoDecimalPrecision, expectedProjectedGraduationGrade[countValuesReceived].twoDecimalPrecision)
                XCTAssertEqual(self.viewModel.expectedGraduationGrade.twoDecimalPrecision, expectedEProjectedGraduationGrade[countValuesReceived].twoDecimalPrecision)
                
                countValuesReceived += 1
            })
        countValuesSent += 1
        
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 23, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 10, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 21, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 12, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 19, name: nil))
        countValuesSent += 1
        
        XCTAssertEqual(countValuesReceived, countValuesSent)
        
        addTeardownBlock {
            subscription.cancel()
            self.viewModel.courses.removeAll()
        }
    }
    
    func testPassedExams() {
        var countValuesReceived = 0
        var countValuesSent = 0
        let expectedPassedExams = [0, 1, 2, 3, 3, 3, 4, 5, 6, 6, 6, 6, 6]
        
        let subscription = self.viewModel.$courses
            .sink(receiveValue: { course in
                XCTAssertNotNil(course)
                XCTAssertEqual(course.count, countValuesReceived)
                XCTAssertEqual(self.viewModel.passedExams, expectedPassedExams[countValuesReceived])
                
                countValuesReceived += 1
            })
        countValuesSent += 1
        
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 30, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 23, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 10, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 21, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context, cfu: 12, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 19, name: nil))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 23))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 10, colorColIndex: 0, colorRowIndex: 0, expectedMark: 21))
        countValuesSent += 1
        self.viewModel.courses.append(Course(context: self.context!, cfu: 12, colorColIndex: 0, colorRowIndex: 0, expectedMark: 19))
        countValuesSent += 1
        
        XCTAssertEqual(countValuesReceived, countValuesSent)
        
        addTeardownBlock {
            subscription.cancel()
            self.viewModel.courses.removeAll()
        }
        
    }
    
    func testDeltaCalculation() {
        let expectedDeltaResults: [Double] = [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
        let expectedDeltaResultsOne: [Double] = [22.50, 23, 23.50, 24, 24.50, 25, 25.50, 26, 26.50, 27, 27.50, 28, 28.50]
        
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 1), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 2), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 3), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 10), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 20), expectedDeltaResults)
        
        XCTAssertEqual(self.viewModel.average, 0.0)
        
        // ExpectedMarks should make no difference
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        self.viewModel.courses.append(Course(context: self.context!, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30))
        
        XCTAssertEqual(self.viewModel.average, 0.0)
        XCTAssertEqual(self.viewModel.expectedAverage, 30.0)
        
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 1), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 2), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 3), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 10), expectedDeltaResults)
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 20), expectedDeltaResults)
        
        self.viewModel.courses.append(Course(context: self.context, cfu: 5, colorColIndex: 0, colorRowIndex: 0, expectedMark: 30, iconName: nil, laude: nil, expectedLaude: nil, mark: 27, name: nil))
        
        XCTAssertEqual(self.viewModel.average, 27.0)
        XCTAssertEqual(self.viewModel.expectedAverage, 30.0)
        
        XCTAssertEqual(self.viewModel.calculateDeltas(withCfu: 5), expectedDeltaResultsOne)
        
        addTeardownBlock {
            self.viewModel.courses.removeAll()
        }
    }
    
}
