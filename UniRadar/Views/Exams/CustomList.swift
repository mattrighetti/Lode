//
//  CustomList.swift
//  UniRadar
//
//  Created by Mattia Righetti on 05/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct CustomList: View {
    
    var values: [String]
    
    @Binding var stringValue: String
    
    var body: some View {
        List {
            ForEach(values, id: \.self) { element in
                Text(element)
            }
        }.listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .compact)
    }
}

struct CustomList_Previews: PreviewProvider {
    @State static var stringValue = "Ciao"
    static var previews: some View {
        CustomList(values: ["Ciao", "Ok"], stringValue: $stringValue)
    }
}
