//
//  TipJarView.swift
//  Lode
//
//  Created by Mattia Righetti on 04/02/21.
//

import SwiftUI

struct TipJarView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .center) {
                    Text("If you want to support my work you can buy me a coffe or a pizza 😋")
                }.padding(.top)
            }.listRowBackground(Color.background)
            Section {
                HStack {
                    Text("☕️ Coffe-Sized Tip")
                        .font(.title3)
                    Spacer()
                    Button(action: {}, label: {
                        Text("0.99$")
                            .font(.system(.title3, design: .rounded))
                            .badgePill(color: .blue)
                    })
                }
                HStack {
                    Text("🥪 Toast-Sized Tip")
                        .font(.title3)
                    Spacer()
                    Button(action: {}) {
                        Text("4.99$")
                            .font(.system(.title3, design: .rounded))
                            .badgePill(color: .blue)
                    }
                }
                HStack {
                    Text("🍕 Pizza-Sized Tip")
                        .font(.title3)
                    Spacer()
                    Button(action: {}) {
                        Text("10.99$")
                            .font(.system(.title3, design: .rounded))
                            .badgePill(color: .blue)
                    }
                }
                HStack {
                    Text("🍣 Sushi-Sized Tip")
                        .font(.title3)
                    Spacer()
                    Button(action: {}) {
                        Text("19.99$")
                            .font(.system(.title3, design: .rounded))
                            .badgePill(color: .blue)
                    }
                }
            }.padding(.vertical, 5)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Tip Jar")
    }
}

struct TipJarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TipJarView()
        }
    }
}
