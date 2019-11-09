//
//  VerticalCapsuleGraphCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 09/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct VerticalCapsuleGraphCard: View {
    
    var datas: [Int] = [1, 30, 5, 9, 4, 12, 2, 7, 1, 9, 13, 23, 45]
    
    var body: some View {
        GeometryReader { screen in
            VStack(alignment: .leading) {
                
                Text("Title")
                    .font(.custom("Avenir Next Bold", size: 20.0))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 0))
                
                HStack {
                    ForEach(self.datas, id: \.self) { data in
                        VerticalCapsuleGraph(value: data, maxValue: self.datas.max()!, labelText: "", width: (screen.size.width / CGFloat(self.datas.count)) - 15, height: screen.size.height / 1.5)
                    }
                }.padding(.horizontal)
                
            }.modifier(Card())
        }
    }
}

struct VerticalCapsuleGraphCard_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCapsuleGraphCard()
    }
}
