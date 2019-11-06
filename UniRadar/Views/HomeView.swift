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
        
        VStack {
            
            Header()
            
            ScrollView {
                
                HStack {
                    RoundProgressBarCard(title: "CFU", cfu: 20, totalCfu: 120, width: 160, height: 160)
                    RoundProgressBarCard(title: "Exams", cfu: 2, totalCfu: 26, width: 160, height: 160)
                }
                
            }.edgesIgnoringSafeArea(.bottom)
            
        }.edgesIgnoringSafeArea(.top)
        
    }
    
}

struct Header: View {
    var body: some View {
        ZStack(alignment: .leading) {
            
            Image("ur_background")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 25)
            
            VStack(alignment: .leading) {
                
                Text("Welcome,")
                    .foregroundColor(Color.white)
                    .font(.custom("Avenir Next Regular", size: 30.0))
                
                
                
                Text("Mario Rossi")
                    .foregroundColor(Color.white)
                    .font(.custom("Avenir Next Bold", size: 50.0))
                
            }.padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
