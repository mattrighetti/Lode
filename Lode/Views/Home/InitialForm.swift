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

    @AppStorage("totalCfu") var totalCfu: Int = 180
    @AppStorage("laudeValue") var laudeValue: Int = 180
    
    private var totalCfuProxy: Binding<Int> {
        Binding<Int>(get: {
            totalCfu
        }, set: {
            self.totalCfu = $0
            totalCfu = $0
        })
    }
    
    private var laudeValueProxy: Binding<Int> {
        Binding<Int>(get: {
            laudeValue
        }, set: {
            self.laudeValue = $0
            laudeValue = $0
        })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Header(title: NSLocalizedString("Total CFUs of your study plan", comment: ""))
                    .padding(.top)
                
                Stepper(value: self.$totalCfu, in: 30...1000) {
                    Text("\(totalCfu)")
                        .font(.title)
                }
                .padding()
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Header(title: NSLocalizedString("How much is a laude evaluated?", comment: ""))
                        .padding(.top)
                
                Stepper(value: self.$laudeValue, in: 30...35) {
                    Text("\(laudeValue)")
                        .font(.title)
                }
                .padding()
                .background(Color("cardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
            }
            .padding(.horizontal)
            .background(Color("background")
                .edgesIgnoringSafeArea(.all))
            .onAppear {
                setViewModelValues(totalCfu, laudeValue)
            }
            
            .navigationBarTitle("Initial setup", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func setViewModelValues(_ totalCfu: Int, _ laudeValue: Int) {
        self.totalCfu = totalCfu
        self.laudeValue = laudeValue
    }
    
}

struct InitialForm_Previews: PreviewProvider {
    static var previews: some View {
        InitialForm()
            .colorScheme(.dark)
            .environment(\.locale, .init(identifier: "it"))
    }
}
