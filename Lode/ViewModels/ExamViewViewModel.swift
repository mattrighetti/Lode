//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

class ExamViewViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Exam.entity(), sortDescriptors: [])
    var exams: FetchedResults<Exam>

    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    var courses: FetchedResults<Course>
}