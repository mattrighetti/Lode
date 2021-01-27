//
//  InfosCard.swift
//  UniRadar
//
//  Created by Mattia Righetti on 19/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct MainInfoCard: View {

    @EnvironmentObject var viewModel: HomeViewViewModel
    
    var closeExams: [Exam] {
        let closest = viewModel.exams.sorted(by: { $0.date! < $1.date! }).filter({ $0.daysLeft > 0 }).prefix(4)
        return Array(closest)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if closeExams.isEmpty {
                VStack {
                    Image("holidays")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .padding(.bottom)
                    
                    HStack {
                        Text("No exam in sight!")
                        Text("🥳")
                    }
                }
            } else {
                Group {
                    HStack {
                        Text("Exam").fontWeight(.bold)
                        Spacer()
                        Text("Days to go").fontWeight(.bold)
                    }
                    
                    Divider().padding(0)
                    
                    ForEach(closeExams, id: \.id) { exam in
                        HStack {
                            Text(exam.title!)
                            Spacer()
                            Text("\(exam.daysLeft)")
                                .modifier(BadgePillStyle(color: exam.daysLeft > 7 ? .blue : .red))
                        }
                    }
                }
            }
        }
        .borderBox(color: closeExams.isEmpty ? .clear : .blue)
        .padding(5)
        .background(Color("cardBackground"))
    }
    
}

struct MainInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        MainInfoCard()
    }
}
