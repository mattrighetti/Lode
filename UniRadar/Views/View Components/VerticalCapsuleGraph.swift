//
//  VerticalCapsuleGraph.swift
//  UniRadar
//
//  Created by Mattia Righetti on 09/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct VerticalCapsuleGraph: View {
    
    var value: Int
    var maxValue: Int
    var labelText: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        GeometryReader { screen in
            
            VStack {
                
                Text("\(self.value)")
                    .font(.custom("Avenir Next Bold", size: 11.0))
                
                ZStack(alignment: .bottom) {
                    
                    Capsule()
                        .foregroundColor(.flatGray)
                        .frame(width: self.width, height: self.height)
                    
                    Capsule()
                        .foregroundColor(.flatDarkBlue)
                        .frame(width: self.width, height: self.height * (CGFloat(self.value) / CGFloat(self.maxValue)))
                    
                }
                
                Text(self.labelText)
                
            }
            
        }
    }
}

struct VerticalCapsuleGraph_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCapsuleGraph(value: 3, maxValue: 10, labelText: "Value", width: 30, height: 240)
    }
}
