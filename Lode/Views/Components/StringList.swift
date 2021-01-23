//
//  StringList.swift
//  UniRadar
//
//  Created by Mattia Righetti on 07/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StringList: View {
    
    var strings: [String]
    
    @Binding var selectedIndex: Int
    
    var body: some View {
        List {
            Section(header: Text("Select a course").padding(.top, 25)) {
                ForEach(strings.indices) { index in
                    Button(action: {
                        self.selectedIndex = index
                    }, label: {
                        HStack {
                            Text(strings[index])
                            Spacer()
                            if selectedIndex == index {
                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                            }
                        }
                    }).buttonStyle(PlainButtonStyle())
                }.listRowBackground(Color("cardBackground"))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct StringList_Previews: PreviewProvider {
    @State static var index: Int = 0
    static var previews: some View {
        StringList(strings: ["Analisi 1", "AAPP", "ACA"], selectedIndex: $index)
            .colorScheme(.dark)
    }
}
