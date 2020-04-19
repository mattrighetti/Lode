//
//  DataCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 16/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct DataCard<Content: View>: View {
    
    var headerTitle: String
    var description: String
    let content: () -> Content
    
    var body: some View {
        ZStack {
            Color("cardBackground")
            VStack {
                content()
                
                VStack {
                    Text("\(headerTitle)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text("\(description)")
                        .font(.body)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                }
                
            }
            
        }.cornerRadius(45)
    }
}

struct DataCard_Previews: PreviewProvider {
    @State private static var progress: CGFloat = 0.5
    static var previews: some View {
        Group {
            DataCard(headerTitle: "EXAMS", description: "Good Boy") {
                CircularProgressBar(progress: $progress)
            }.environment(\.colorScheme, .dark)
            
            DataCard(headerTitle: "BarChart", description: "Bang dude") {
                EmptyView()
            }
        }
    }
}
