//
//  StringList.swift
//  UniRadar
//
//  Created by Mattia Righetti on 07/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct StringList: View {
    
    var courses: [Course]
    
    @Binding var selectedIndex: Int
    
    var body: some View {
        List {
            Section(header: Text("Select a course").padding(.top, 25)) {
                ForEach(courses.indices) { index in
                    Button(action: {
                        self.selectedIndex = index
                    }, label: {
                        HStack {
                            Text(courses[index].name)
                            Spacer()
                            if selectedIndex == index {
                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                            }
                        }
                    })
                    .padding(.vertical, 7)
                }
                .listRowBackground(Color("cardBackground"))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
