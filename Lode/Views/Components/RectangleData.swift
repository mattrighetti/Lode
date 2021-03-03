//
//  RectangleData.swift
//  Lode
//
//  Created by Mattia Righetti on 02/03/21.
//

import SwiftUI

struct RectangleData: View {
    let title: String
    let data: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Text(data)
                    .font(.system(size: 23, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15.0)
                .fill(color)
        )
    }
}

struct RectangleData_Previews: PreviewProvider {
    static var previews: some View {
        RectangleData(title: "Title", data: "34", color: .orange).frame(width: 200, height: 100, alignment: .center)
    }
}
