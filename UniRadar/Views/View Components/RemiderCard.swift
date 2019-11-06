//
//  SwiftUIView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 06/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct RemiderCard: View {
    
    var reminder: Reminder
    
    var body: some View {
        HStack(spacing: 5) {

            ZStack {

                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 5,
                        lineCap: .butt)
                    )
                    .fill(reminder.color)
                    .padding(10)
                    .frame(width: 100, height: 100)

                VStack {

                    Text("\(reminder.daysLeft)")
                        .font(.custom("Avenir Next Bold", size: 20.0))
                        .foregroundColor(.flatBlack)

                    Text("days left")
                        .font(.custom("Avenir Next Regular", size: 15.0))
                        .foregroundColor(.flatBlack)
                    
                }

            }

            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(reminder.title)
                        .font(.custom("Avenir Next Bold", size: 20.0))
                        .foregroundColor(.flatBlack)
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

                    Text(reminder.description)
                        .font(.custom("Avenir Next Regular", size: 15.0))
                        .foregroundColor(.flatBlack)
                        .lineLimit(3)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                }
            }.overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        Color(.sRGB,
                            red: 150 / 255,
                            green: 150 / 255,
                            blue: 150 / 255,
                            opacity: 0.1),
                        lineWidth: 1
                    )
            )

            Spacer()

        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RemiderCard(reminder: Reminder(daysLeft: 32, title: "Spesa", description: "Ricorda di prendere il dentifricio", color: .yellow))
    }
}
