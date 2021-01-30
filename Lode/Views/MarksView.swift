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
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(viewModel.courses, id: \.id) { course in
                    MarkCard(course: course)
                }
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
        }
        .onDisappear {
            presentationMode.wrappedValue.dismiss()
        }

        .navigationBarTitle( NSLocalizedString("Marks", comment: "") )
    }

}

struct MarkCard: View {

    var course: Course
    
    var markIcon: Color {
        guard course.mark != 0 else {
            return .orange
        }

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

    var body: some View {
        ZStack {
            Color.cardBackground
            VStack(alignment: .leading, spacing: 10) {
                Text(course.name!).font(.headline).fontWeight(.bold)
                
                HStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text(expectedMarkString)
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

    @ViewBuilder
    private func content() -> some View {
        if course.mark != 0 {
            Text(markString).font(.system(.title, design: .rounded)).fontWeight(.bold)
        } else {
            Text("?").font(.system(.title, design: .rounded)).fontWeight(.bold)
        }
    }

}

struct MarksView_Previews: PreviewProvider {
    static var previews: some View {
        let course = Course()
        course.cfu = 5
        course.color = Color.flatRed.toHex
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
