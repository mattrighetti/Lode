//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

class CourseViewViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    var courses: FetchedResults<Course>
}