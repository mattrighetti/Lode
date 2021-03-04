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
    
    private var title: String {
        assignment.title.isEmpty ? "No title" : assignment.title
    }
    
    private var caption: String {
        assignment.caption.isEmpty ? "No description" : assignment.caption
    }

    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color(hex: assignment.color)!)
                daysMissingView()
            }
            .frame(width: 70, height: 70, alignment: .center)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .layoutPriority(1)
                    .padding(.bottom, 5)
                Text(caption)
                    .font(.caption)
                    .lineLimit(3)
                badge()
            }
            Spacer()
        }
        .card()
    }
    
    @ViewBuilder
    func daysMissingView() -> some View {
        if assignment.daysLeft > 0 {
            VStack {
                Text("\(assignment.daysLeft)")
                    .font(.system(size: 25.0, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("missing")
                    .font(.system(size: 10.0, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        } else if assignment.daysLeft == 0 {
            VStack {
                Text("Today")
                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        } else {
            VStack {
                Text("\(assignment.daysLeft * -1)")
                    .font(.system(size: 25.0, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("days ago")
                    .font(.system(size: 10.0, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
    
    @ViewBuilder
    func badge() -> some View {
        if assignment.daysLeft < 3 && assignment.daysLeft > 0 {
            HStack {
                Image(systemName: "exclamationmark.circle")
                Text("Due soon")
            }
            .badgePill(color: .red)
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
