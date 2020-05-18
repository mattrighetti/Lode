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
    
    @State private var totalCfu: Int = 180
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Header(title: NSLocalizedString("Total CFUs of your study plan", comment: "")).padding(.top)
                
                CustomStepper(value: self.$totalCfu, maxValue: 1000, minValue: 0)
                
            }
            .padding(.horizontal)
            .background(Color("background").edgesIgnoringSafeArea(.all))
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text("Some fields are not compiled"),
                    message: Text("You have to compile every field to create a course"),
                    dismissButton: .cancel(Text("Ok"))
                )
            }

            .navigationBarTitle("Initial setup", displayMode: .large)
            .navigationBarItems(
                trailing: Button("Done") {
                    UserDefaults.standard.set(self.totalCfu, forKey: "totalCfu")
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct InitialForm_Previews: PreviewProvider {
    static var previews: some View {
        InitialForm().colorScheme(.dark)
            .environment(\.locale, .init(identifier: "it"))
    }
}
