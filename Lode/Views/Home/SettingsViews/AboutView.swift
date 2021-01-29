//
//  AboutView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 22/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    HStack {
                        Image(uiImage: UIImage(named: "main.png")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)

                        VStack(alignment: .leading) {
                            Text("Lode \((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)")
                                .font(.system(size: 20.0, design: .rounded))
                                .bold()
                                .padding(.bottom)
                            Text("by Mattia Righetti")
                        }
                    }
                    Spacer()
                }
            }.listRowBackground(Color("background"))

            Section(header: Text("Developer info"), footer: Text("")) {
                Button(action: {
                    UIApplication.shared.open(URL(string: "mailto:matt95.righetti@gmail.com")!)
                }, label: {
                    HStack {
                        Text("Email")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                })

                Button(action: {

                }, label: {
                    HStack {
                        Text("Rate Lode")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                })
            }.listRowBackground(Color("cardBackground"))
        }
        .listStyle(InsetGroupedListStyle())

        .navigationBarTitle("About", displayMode: .inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .colorScheme(.dark)
    }
}
