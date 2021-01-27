//
// Created by Mattia Righetti on 27/01/21.
//

import Foundation
import Combine

class AverageDeltaToolViewModel: ObservableObject {
    @Published var courses: [Course] = [] {
        willSet {
            gainedCfu = newValue.filter { $0.mark != 0 }.compactMap { Double($0.cfu) }.reduce(0, { $0 + $1 })
            average = courses
                    .filter { $0.mark != 0 }
                    .compactMap { Double($0.cfu) * Double($0.mark) }
                    .reduce(0, { $0 + $1 }) / gainedCfu
        }
    }
    @Published var gainedCfu: Double = 0.0
    @Published var average: Double = 0.0

    private var cancellable: AnyCancellable?

    init() {
        cancellable = CourseStorage.shared.courses.sink { courses in
            self.courses = courses
        }
    }

    public func calculateDeltas(withCfu cfu: Int) -> [Double] {
        var deltas = [Double]()
        let average = courses.filter { $0.mark != 0 }.map { Double($0.mark * $0.cfu) }.reduce(0, { $0 + $1 })
        let gainedCfu = Double(self.gainedCfu) + Double(cfu)

        guard gainedCfu != 0 else {
            for mark in 18...30 {
                deltas.append(Double(mark))
            }

            return deltas
        }

        var tmp = 0.0
        for mark in 18...30 {
            tmp = average
            tmp += (Double(mark) * Double(cfu))
            tmp /= gainedCfu
            deltas.append(tmp)
        }

        return deltas
    }
}