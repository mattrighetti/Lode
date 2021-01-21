//
//  Cards.swift
//  UniRadar
//
//  Created by Mattia Righetti on 09/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CfuCard: View {

    @AppStorage("totalCfu") var totalCfu: Int = 180
    @Binding var gainedCfu: Int

    var body: some View {
        ZStack {
            CircularProgressBar(
                progress: CGFloat(gainedCfu) / CGFloat(totalCfu)
            )
            Text("\(gainedCfu)").font(.system(size: 30, weight: .bold, design: .rounded))
        }.background(Color("cardBackground"))
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        CfuCard(gainedCfu: .constant(180)).colorScheme(.dark)
    }
}
