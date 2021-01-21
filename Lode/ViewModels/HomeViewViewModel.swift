//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

class HomeViewViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    var courses: FetchedResults<Course>

    @FetchRequest(entity: Assignment.entity(), sortDescriptors: [])
    var assignments: FetchedResults<Assignment>

    @FetchRequest(entity: Exam.entity(), sortDescriptors: [])
    var exams: FetchedResults<Exam>
}