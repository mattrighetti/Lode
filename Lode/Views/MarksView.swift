//
//  MarksView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MarksView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = MarksViewViewModel()

    var body: some View {
        dataContent()
            .background(Color.background.ignoresSafeArea())

        .navigationBarTitle( NSLocalizedString("Marks", comment: "") )
    }

    @ViewBuilder
    func dataContent() -> some View {
        if viewModel.courses.count > 0 {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(viewModel.courses, id: \.id) { course in
                        MarkCard(course: course)
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
            }
        } else {
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    Image(systemName: "xmark.seal.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.flatRed)
                    Text("No data available to show")
                        .font(.system(size: 20.0, weight: .regular, design: .rounded))
                }
            }
        }
    }
}

struct MarkCard: View {
    var course: Course
    
    var abbreviatedCourseTitle: String? {
        let toRemove = ["and", "e", "of", "di"]
        if course.name.count > 25 {
            let splitString = course.name
                .split { $0 == " " }
                .map { String($0) }
                .filter { !toRemove.contains($0) }
            
            return splitString.map({ String($0.first!).uppercased() }).reduce("", +)
        }
        return nil
    }
    
    var markIcon: Color {
        guard course.mark != 0 else { return .orange }
        if course.mark >= course.expectedMark {
            return .green
        }
        return .red
    }
    
    var expectedMarkString: String {
        if course.expectedMark == 31 {
            return "30L"
        } else {
            return "\(course.expectedMark)"
        }
    }
    
    var markString: String {
        if course.mark == 31 {
            return "30L"
        } else {
            return "\(course.mark)"
        }
    }
    
    var finalMark: String {
        if course.mark != 0 {
            return markString
        } else {
            return "?"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(abbreviatedCourseTitle ?? course.name)
                .font(.system(size: 20.0, weight: .semibold, design: .rounded))
            HStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.orange)
                    .frame(width: 3, height: 15, alignment: .center)
                Text("Expected \(expectedMarkString)")
                Spacer()
            }
            HStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.red)
                    .frame(width: 3, height: 15, alignment: .center)
                Text("Final \(finalMark)")
                Spacer()
            }
        }
        .card()
    }
}

struct MarksView_Previews: PreviewProvider {
    static var previews: some View {
        let course = Course()
        course.cfu = 5
        course.color = Color.flatRed.toHex!
        course.expectedMark = 19
        course.laude = true
        course.expectedLaude = false
        course.iconName = "pencil"
        course.id = UUID()
        course.mark = 31
        course.name = "Analisi 1"
        
        return Group {
            MarkCard(course: course).previewDevice("iPhone 11")
        }
        .environment(\.colorScheme, .dark)
    }
}
