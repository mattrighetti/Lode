//
//  Cards.swift
//  UniRadar
//
//  Created by Mattia Righetti on 09/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CfuCard: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            CircularProgressBar(
                progress: CGFloat(self.viewModel.gainedCfu) / CGFloat(self.viewModel.totalCfu)
            )
            Text("\(self.viewModel.gainedCfu)").font(.system(size: 30, weight: .bold, design: .rounded))
        }.background(Color("cardBackground"))
    }
}

struct Cards_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static var previews: some View {
        CfuCard(viewModel: ViewModel(context: context!)).colorScheme(.dark)
    }
}