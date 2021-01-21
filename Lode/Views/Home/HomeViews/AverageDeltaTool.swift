//
//  AverageDeltaTool.swift
//  UniRadar
//
//  Created by Mattia Righetti on 22/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AverageDeltaTool: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel = AverageDeltaViewViewModel()
    
    @State var cfu: Int = 5
    @State var deltas: [Double] = [Double]()
    
    var valueStrings: [String] {
        var strings = [String]()
        for i in 18...30 {
            strings.append("\(i)")
        }
        return strings
    }
    
    var cfuProxy: Binding<Int> {
        Binding<Int>(get: {
            cfu
        }, set: {
            self.cfu = $0
            self.deltas = viewModel.calculateDeltas(withCfu: $0)
        })
    }
    
    var body: some View {
        List {
            Section(header: Text("Course CFU").sectionTitle(),
                    footer: Text("TWAY")) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(cfu)")
                        .font(.system(size: 50.0, weight: .bold, design: .rounded))
                        .padding()
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Stepper("", value: cfuProxy, in: 1...30)
                        .labelsHidden()
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            .listRowBackground(Color("cardBackground"))
            
            Section(header: Text("Current average").sectionTitle()) {
                Text("\(viewModel.average.twoDecimalPrecision)").bold()
            }.listRowBackground(Color("cardBackground"))
            
            Section(header: Text("New average").sectionTitle()) {
                ForEach(deltas.indices, id: \.self) { index in
                    HStack {
                        Text(valueStrings[index])
                        Spacer()
                        Text("\(deltas[index].twoDecimalPrecision)")
                            .foregroundColor(deltas[index] < viewModel.average ? .red : .green)
                    }
                }
            }
            .listRowBackground(Color("cardBackground"))
            
        }
        .singleSeparator()
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .onAppear {
            self.deltas = viewModel.calculateDeltas(withCfu: cfu)
        }
        .onDisappear {
            presentationMode.wrappedValue.dismiss()
        }
        
        .navigationBarTitle("Delta Calculator")
    }
    
}

struct AverageDeltaTool_Previews: PreviewProvider {
    static var previews: some View {
        AverageDeltaTool()
            .colorScheme(.dark)
    }
}
