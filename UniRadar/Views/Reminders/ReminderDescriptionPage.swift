//
//  ReminderDescriptionPage.swift
//  UniRadar
//
//  Created by Mattia Righetti on 23/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct ReminderDescriptionPage: View {
    
    var assignment: Assignment?
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            Group {
                if self.assignment != nil {
                    VStack {
                        VStack {
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(Color.gradientsPalette[Int(self.assignment!.colorRowIndex)][Int(self.assignment!.colorColumnIndex)])
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                            
                            Text(self.assignment!.title!)
                                .font(.system(.largeTitle, design: .rounded))
                                .bold()
                        }
                        .padding(.bottom, 20)
                        
                        Spacer()
                    }.padding()
                } else {
                    Text("Select an assignment")
                }
            }
        }
    }
}

struct ReminderDescriptionPage_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDescriptionPage()
    }
}
