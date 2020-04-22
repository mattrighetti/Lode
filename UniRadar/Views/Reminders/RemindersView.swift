//
//  RemindersView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 20/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct Reminder: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let expirationDate: Date
}

struct RemindersView: View {
    
    init() {
        // Make Dividers the same color as the background to make them disappear
        UITableView.appearance().separatorColor = UIColor(named: "background")
        // Set List background color
        UITableView.appearance().backgroundColor = UIColor(named: "background")
        UIPickerView.appearance().backgroundColor = UIColor(named: "background")
    }
    
    @State var showForm: Bool = false
    @State var pickerData = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                VStack {
                    Picker(selection: .constant(1), label: Text("Picker")) {
                        Text("Current").tag(1)
                        Text("Past").tag(2)
                    }
                    .foregroundColor(Color.blue)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List {
                        ReminderRow(title: "AAPP assignment", description: "Make the OpenMP algorithm challenge", daysLeft: 3).listRowBackground(Color("background"))
                        ReminderRow(title: "AAPP assignment", description: "Make the OpenMP algorithm challenge", daysLeft: 7).listRowBackground(Color("background"))
                        ReminderRow(title: "AAPP assignment", description: "Make the OpenMP algorithm challenge", daysLeft: 1).listRowBackground(Color("background"))
                    }
                }
                .navigationBarTitle("Reminders")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: { self.showForm.toggle() }, label: { Image(systemName: "plus.circle") }))
            }
        }.sheet(isPresented: $showForm) {
            ReminderForm()
        }
    }
}

struct ReminderRow: View {
    
    var title: String
    var description: String
    var daysLeft: Int
    var colors: [Color] = [.flatDarkRed, .flatLightRed]
    
    var body: some View {
        ZStack{
            Color("cardBackground")
            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: colors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack {
                        Text("\(daysLeft)").foregroundColor(.white).fontWeight(.bold)
                        Text("missing").foregroundColor(.white)
                    }
                }.frame(width: 100, height: 80, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text(description)
                        .font(.caption)
                        .lineLimit(2)
                    
                    isDueSoon()
                }
                
                Spacer()
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
    
    func isDueSoon() -> some View {
        if daysLeft < 5 {
            return AnyView(
                HStack {
                    Image(systemName: "exclamationmark.circle")
                    Text("Due soon")
                }
                .padding(10)
                .background(Color.flatLightRed)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
            )
        } else {
            return AnyView(
                EmptyView()
            )
        }
    }
    
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
        .previewDevice("iPhone 11")
            .environment(\.colorScheme, .dark)
    }
}
