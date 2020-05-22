//
//  MarksView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MarksView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var courses: [Course]

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

    var body: some View {
        ZStack {
            Color("cardBackground")
            VStack(alignment: .leading, spacing: 10) {
                Text(course.name!).font(.headline).fontWeight(.bold)
                
                HStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text("\(course.expectedMark)")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                            
                            Text("Expected").modifier(BadgePillStyle(color: .blue))
                        }.frame(width: 100)
                        
                        Divider().background(Color("background"))
                        
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
            return AnyView( Text(String(course.mark)).font(.system(.title, design: .rounded)).fontWeight(.bold) )
        } else {
            return AnyView( Text("?").font(.system(.title, design: .rounded)).fontWeight(.bold) )
        }
    }

}

struct MarksView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    @ObservedObject static var viewModel: ViewModel = ViewModel(context: context!)
    static var previews: some View {
        let course = Course(context: context!)
        course.name = "Advanced Algorithms and Parallel Programming"
        course.cfu = 5
        course.expectedMark = 25
        course.mark = 0
        
        return Group {
            MarksView(courses: [course]).previewDevice("iPhone 11")
            MarkCard(course: course).previewDevice("iPhone 11")
        }
        .environment(\.colorScheme, .dark)
    }
}
