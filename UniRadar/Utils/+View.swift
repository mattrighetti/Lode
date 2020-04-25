//
//  +View.swift
//  UniRadar
//
//  Created by Mattia Righetti on 24/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

extension View {
    func navigationBarItems<L, C, T>(leading: L, center: C, trailing: T) -> some View where L: View, C: View, T: View {
        self.navigationBarItems(leading:
            HStack{
                HStack {
                    leading
                }
                .frame(width: 50, alignment: .leading)
                Spacer()
                HStack {
                    center
                }
                .frame(width: 200, alignment: .center)
                Spacer()
                HStack {
                    //Text("asdasd")
                    trailing
                }
                //.background(Color.blue)
                .frame(width: 50, alignment: .trailing)
            }
            //.background(Color.yellow)
            .frame(width: UIScreen.main.bounds.size.width - 32)

        )

    }
}
