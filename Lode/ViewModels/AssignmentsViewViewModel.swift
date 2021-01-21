//
// Created by Mattia Righetti on 21/01/21.
//

import Foundation
import SwiftUI

class AssignmentViewViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Assignment.entity(), sortDescriptors: [])
    var assignments: FetchedResults<Assignment>
}