//
// Created by Mattia Righetti on 29/01/21.
//

import SwiftUI

struct ContributingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var githubIcon: String {
        colorScheme == .dark ? "github-logo-light" : "github-logo"
    }
    
    var body: some View {
        List {
            Section(header: Text("Code").fontWeight(.semibold)) {
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://github.com/mattrighetti/Lode")!)
                }, label: {
                    Label(title: {
                        Text("Github respository")
                    }) {
                        CircledIcon(color: .white) {
                            Image(uiImage: UIImage(named: "github-50.png")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaledToFit()
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    }
                })
                .padding(.vertical, 7)
            }
            .listRowBackground(Color("cardBackground"))
        }
        .listStyle(InsetGroupedListStyle())
        .background(Color.background.ignoresSafeArea())

        .navigationBarTitle("Contribute", displayMode: .inline)
    }
}
