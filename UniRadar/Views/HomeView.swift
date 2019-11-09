//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        GeometryReader { screen in
            VStack {
                
                Header()
                    .frame(width: screen.size.width, height: screen.size.height / 2)
                
                VStack {
                    HStack {
                        RoundProgressBarCard(title: "CFU", cfu: 20, totalCfu: 120, width: screen.size.width / 2.8, height: screen.size.width / 3, color: .flatDarkRed).padding(.vertical, 10)
                        
                        RoundProgressBarCard(title: "Exams", cfu: 2, totalCfu: 26, width: screen.size.width / 2.8, height: screen.size.width / 3, color: .flatDarkBlue).padding(.vertical, 10)
                    }
                    
                    HorizontalCapsuleGraph(title: "Mean",
                                value: 22.47,
                                maxValue: 30,
                                aimedValue: 28,
                                width: screen.size.width - 130,
                                height: 20
                    ).padding(5)
                    
                    HorizontalCapsuleGraph(title: "Final Score",
                                value: (22.47 * 11) / 3,
                                maxValue: 110,
                                aimedValue: (28 * 11) / 3,
                                width: screen.size.width - 130,
                                height: 20
                    ).padding(5)
                    
                }.offset(x: 0, y: -(screen.size.height / 6))
                               
            }
        }
        
    }
    
}

struct Header: View {
    var body: some View {
        ZStack(alignment: .center) {
            
            Image("ur-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("Welcome,")
                        .foregroundColor(Color.white)
                        .font(.custom("Avenir Next Regular", size: 20.0))
                    
                    Text("Matt")
                        .foregroundColor(Color.white)
                        .font(.custom("Avenir Next Bold", size: 40.0))
                    
                }.padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
