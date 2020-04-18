//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    var username: String = "Mattia"
    
    var body: some View {
        ZStack {
            Color.flatDarkBlue
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Header(username: username)
                ContentCard()
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct Header: View {
    
    var username: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Hello, \(username)")
                    .foregroundColor(.white)
                    .font(.system(size: 35.0))
                    .fontWeight(.bold)
                
                Text("Hope you're doing great today!")
                    .foregroundColor(.white)
                
            }.padding(20)
            
            Spacer()
        }
    }
}

struct ContentCard: View {
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            
            HorizontalCardSection(sectionTitle: "Your info", height: 250) {
                Group {
                    DataCard(headerTitle: "CFU", cardColor: .flatDarkBlue) {
                        CircularProgressBar(currentValue: 25, maxValue: 100, color: .white)
                    }
                    
                    DataCard(headerTitle: "AVERAGE", cardColor: .flatLightRed) { CircularProgressBar(currentValue: 60, maxValue: 100, color: .flatDarkGray)
                    }
                    
                    DataCard(headerTitle: "EXAMS", cardColor: .red) {
                        CircularProgressBar(currentValue: 100, maxValue: 100, color: .flatDarkGray)
                    }
                }
            }
        }.clipShape(RoundedRectangle(cornerRadius: 35))
    }
}

struct HorizontalCardSection<Content: View>: View {
    
    var sectionTitle: String
    var height: CGFloat
    var content: () -> Content
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(sectionTitle)
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                    .padding([.top, .leading], 20)
            
                HStack {
                    content()
                }
            }.frame(height: height, alignment: .center)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
