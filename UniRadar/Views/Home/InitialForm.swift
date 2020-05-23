//
//  InitialForm.swift
//  UniRadar
//
//  Created by Mattia Righetti on 17/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct InitialForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var totalCfu: Int = 180
    @State private var laudeValue: Int = 30
    
    private var totalCfuProxy: Binding<Int> {
        Binding<Int>(get: {
            self.totalCfu
        }, set: {
            self.totalCfu = $0
            self.viewModel.totalCfu = $0
        })
    }
    
    private var laudeValueProxy: Binding<Int> {
        Binding<Int>(get: {
            self.laudeValue
        }, set: {
            self.laudeValue = $0
            self.viewModel.laudeValue = $0
        })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Header(title: NSLocalizedString("Total CFUs of your study plan", comment: "")).padding(.top)
                
                Stepper(value: self.$totalCfu, in: 30...1000) {
                    Text("\(self.totalCfu)")
                        .font(.title)
                }
                .padding()
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Header(title: NSLocalizedString("How much is a laude evaluated?", comment: "")).padding(.top)
                
                Stepper(value: self.$laudeValue, in: 30...35) {
                    Text("\(self.laudeValue)")
                        .font(.title)
                }
                .padding()
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
            }
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .onAppear {
                self.setViewModelValues(self.totalCfu, self.laudeValue)
            }
            
            .navigationBarTitle("Initial setup", displayMode: .large)
            .navigationBarItems(
                trailing: Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func setViewModelValues(_ totalCfu: Int, _ laudeValue: Int) {
        self.viewModel.totalCfu = totalCfu
        self.viewModel.laudeValue = laudeValue
    }
    
}

struct InitialForm_Previews: PreviewProvider {
    static var previews: some View {
        InitialForm(viewModel: ViewModel(context: .init(concurrencyType: .mainQueueConcurrencyType))).colorScheme(.dark)
            .environment(\.locale, .init(identifier: "it"))
    }
}
