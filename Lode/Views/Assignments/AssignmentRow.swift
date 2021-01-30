//
//  AssignmentRow.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AssignmentRow: View {
    var assignment: Assignment

    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color(hex: assignment.color!)!)

                VStack {
                    Text("\(assignment.daysLeft)")
                        .font(.system(size: 25.0, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("missing")
                        .font(.system(size: 10.0, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }.frame(width: 70, height: 70, alignment: .center)

            VStack(alignment: .leading) {
                Text(assignment.title ?? "No title")
                    .font(.headline)
                    .fontWeight(.bold)
                    .layoutPriority(1)
                    .padding(.bottom, 5)

                Text(assignment.caption ?? "No description")
                    .font(.caption)
                    .lineLimit(3)

                isDueSoon()
            }

            Spacer()
        }.card()
    }

    func isDueSoon() -> some View {
        if assignment.daysLeft < 5 {
            return AnyView(
                HStack {
                    Image(systemName: "exclamationmark.circle")
                    Text("Due soon")
                }.badgePill(color: .red)
            )
        } else {
            return AnyView(
                EmptyView()
            )
        }
    }

}

struct AssignmentRow_Previews: PreviewProvider {
    static var previews: some View {
        let assignment = Assignment()
        assignment.title = "Start studying Artificial Intelligence"
        assignment.caption = "Start from the  bottom Start from the  bottom Start from the  bottom Start from the  bottom Start from the  bottom"
        assignment.dueDate = Date(timeIntervalSince1970: TimeInterval(exactly: 1589979887.0)!)
        return List {
            AssignmentRow(assignment: assignment)
        }
    }
}
