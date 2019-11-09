//
//  StatisticsView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 09/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        GeometryReader { screen in
            VStack {

                StatisticsHeader()
                    .frame(width: screen.size.width, height: screen.size.height / 2)

                VerticalCapsuleGraphCard()
                    .padding()
                    .frame(height: screen.size.height / 1.5)
                    .offset(x: 0, y: -120)

                Spacer()
            }

        }.edgesIgnoringSafeArea(.top)
    }
}

struct StatisticsHeader: View {
    var body: some View {
        ZStack(alignment: .center) {
            
            Image("ur-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("Statistics")
                        .foregroundColor(Color.white)
                        .font(.custom("Avenir Next Bold", size: 40.0))
                    
                }.padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
