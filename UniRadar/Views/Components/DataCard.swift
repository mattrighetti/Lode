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
    var cardColor: Color
    let content: () -> Content
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .topLeading) {
                self.cardColor
                
                VStack(alignment: .leading) {
                    Text(self.headerTitle)
                        .font(.system(size: screen.size.width / 8))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    self.content()
                    
                }.padding(screen.size.width / 10)
                
            }.clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}

struct DataCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataCard(headerTitle: "EXAMS", cardColor: .flatDarkBlue) {
                CircularProgressBar(currentValue: 10, maxValue: 100, color: .flatDarkGray)
            }
            
            DataCard(headerTitle: "BarChart", cardColor: .flatDarkBlue) {
                BarChartView(arrayValues: [1, 2, 3, 4, 5, 6, 7, 8, 9, 20], color: .flatDarkRed)
            }
        }
    }
}
