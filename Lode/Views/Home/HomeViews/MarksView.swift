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
    
    @State var courses: FetchedResults<Course>

    var body: some View {
        List {
            ForEach(courses, id: \.id) { course in
                MarkCard(course: course)
                    .listRowBackground(Color("background"))
            }
        }
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }

        .navigationBarTitle( NSLocalizedString("Marks", comment: "") )
    }

}

struct MarkCard: View {

    var course: Course
    
    var markIcon: Color {
        guard self.course.mark != 0 else {
            return .orange
        }

        if self.course.mark >= self.course.expectedMark {
            return .green
        }

        return .red
    }
    
    var expectedMarkString: String {
        if self.course.expectedMark == 31 {
            return "30L"
        } else {
            return "\(self.course.expectedMark)"
        }
    }
    
    var markString: String {
        if self.course.mark == 31 {
            return "30L"
        } else {
            return "\(self.course.mark)"
        }
    }

    var body: some View {
        ZStack {
            Color.cardBackground
            VStack(alignment: .leading, spacing: 10) {
                Text(course.name!).font(.headline).fontWeight(.bold)
                
                HStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text(self.expectedMarkString)
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                            
                            Text("Expected").modifier(BadgePillStyle(color: .blue))
                        }.frame(width: 100)
                        
                        Divider()
                        
                        VStack {
                            content()
                            
                            Text("Final").modifier(BadgePillStyle(color: .green))
                        }.frame(width: 100)
                    }.modifier(BorderBox(color: Color("background")))
                    Spacer()
                }
            }.padding()
        }.cornerRadius(25)
    }
    
    private func content() -> some View {
        if self.course.mark != 0 {
            return AnyView( Text(markString).font(.system(.title, design: .rounded)).fontWeight(.bold) )
        } else {
            return AnyView( Text("?").font(.system(.title, design: .rounded)).fontWeight(.bold) )
        }
    }

}

struct MarksView_Previews: PreviewProvider {
    static var previews: some View {
        let course = Course()
        course.cfu = 5
        course.colorColIndex = 0
        course.colorRowIndex = 0
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
