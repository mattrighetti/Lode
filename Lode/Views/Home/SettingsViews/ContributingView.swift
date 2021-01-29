//
// Created by Mattia Righetti on 29/01/21.
//

import SwiftUI

struct ContributingView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .center) {
                    Text("Coming soon...")
                        .font(.system(size: 35.0))
                        .padding(.bottom)

                    Text("This application is going to be open sourced as soon as it gets out of beta")
                            .font(.caption)
                }
            }.listRowBackground(Color("background"))

            Section {
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://github.com/mattrighetti")!)
                }, label: {
                    Label(title: { Text("Github code") }) {
                        Image(systemName: "chevron.right")
                    }
                })
            }.listRowBackground(Color("cardBackground"))
        }
        .listStyle(InsetGroupedListStyle())

        .navigationBarTitle("Contribute", displayMode: .inline)
    }
}
