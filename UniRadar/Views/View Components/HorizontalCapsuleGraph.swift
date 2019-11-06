//
//  GenericCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct HorizontalCapsuleGraph: View {
    
    var title: String
    var value: Double
    var maxValue: Double
    var aimedValue: Double
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(.custom("Avenir Next Bold", size: 20.0))
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
            
            CapsuleProgressBar(value: self.value, maxValue: self.maxValue, aimedValue: self.aimedValue, width: self.width, height: self.height)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            
        }.overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
        )
    }
}

struct CapsuleProgressBar: View {
    
    var value: Double
    var maxValue: Double
    var aimedValue: Double
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        
        HStack {
            
            ZStack(alignment: .bottomLeading) {
                
                Capsule()
                    .foregroundColor(.flatGray)
                    .frame(width: self.width, height: self.height)
                
                Capsule()
                    .foregroundColor(.flatDarkBlue)
                    .opacity(0.4)
                    .frame(width: (CGFloat(aimedValue) / CGFloat(maxValue)) * self.width, height: self.height)
                    .animation(.easeIn(duration: 2))
                
                Capsule()
                    .foregroundColor(.flatDarkBlue)
                    .frame(width: (CGFloat(value) / CGFloat(maxValue)) * self.width, height: self.height)
                    .animation(.easeIn(duration: 2))
                
            }
            
            VStack {
                Text("\(aimedValue.twoDecimalPrecision)")
                    .foregroundColor(.flatDarkBlue)
                    .opacity(0.4)
                    .font(.custom("Avenir Next Regular", size: 20.0))
                
                Text("\(value.twoDecimalPrecision)")
                    .foregroundColor(.flatDarkBlue)
                    .font(.custom("Avenir Next Regular", size: 20.0))
                    .padding(.bottom, 15)
            }
            
        }
        
    }
    
}

struct GenericCard_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCapsuleGraph(title: "Media", value: 18, maxValue: 30, aimedValue: 27, width: 190, height: 20)
    }
}
