//
//  ExamsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 21/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ExamsView: View {
    
    init() {
        // Make Dividers the same color as the background to make them disappear
        UITableView.appearance().separatorColor = UIColor(named: "background")
        // Set List background color
        UITableView.appearance().backgroundColor = UIColor(named: "background")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                VStack {
                    Picker(selection: .constant(1), label: Text("Picker")) {
                        Text("Upcoming").tag(1)
                        Text("Past").tag(2)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List {
                        ExamRow(exam: Exam()).listRowBackground(Color("background"))
                    }
                }
                .navigationBarTitle("Exams")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {  }, label: { Image(systemName: "plus.circle") }))
            }
        }
    }
}

// TODO do not force unwrap values
struct ExamRow: View {
    
    var exam: Exam
    
    var body: some View {
        ZStack {
            Color("cardBackground")
            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .flatLightRed]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: "pencil").font(.system(size: 30))
                }.frame(width: 70, height: 70, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("Anal 1")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom)
                    
                    Text("Difficulty: 1").font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Fri").font(.system(size: 20, weight: .regular, design: .monospaced))
                    Text("24").font(.system(size: 20, weight: .regular, design: .monospaced))
                    Text("Dec").font(.system(size: 20, weight: .regular, design: .monospaced))
                }
            }.padding()
        }.clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct ExamsView_Previews: PreviewProvider {
    static var previews: some View {
        ExamsView().environment(\.colorScheme, .dark)
    }
}
