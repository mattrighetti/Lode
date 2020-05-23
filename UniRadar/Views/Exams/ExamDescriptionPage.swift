//
//  ExamDescriptionPage.swift
//  UniRadar
//
//  Created by Mattia Righetti on 23/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamDescriptionPage: View {
    
    var exam: Exam?
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            Group {
                if self.exam != nil {
                    VStack {
                        VStack {
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(Color.gradientsPalette[Int(self.exam!.colorRowIndex)][Int(self.exam!.colorColIndex)])
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                            
                            Text(self.exam!.title!)
                                .font(.system(.largeTitle, design: .rounded))
                                .bold()
                        }
                        .padding(.bottom, 20)
                        
                        Spacer()
                    }.padding()
                } else {
                    Text("Select an exam")
                }
            }
        }
    }
}

struct ExamDescriptionPage_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        let exam = Exam(context: context!)
        exam.colorColIndex = 0
        exam.colorRowIndex = 0
        exam.date = Date()
        exam.id = UUID()
        exam.title = "Title"
        return ExamDescriptionPage(exam: exam)
    }
}
