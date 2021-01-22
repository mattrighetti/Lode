//
//  AverageDeltaTool.swift
//  UniRadar
//
//  Created by Mattia Righetti on 22/05/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct AverageDeltaTool: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(entity: Course.entity(), sortDescriptors: [])
    private var courses: FetchedResults<Course>
    
    @State var cfu: Int = 5
    @State var deltas: [Double] = [Double]()
    
    var valueStrings: [String] {
        var strings = [String]()
        for i in 18...30 {
            strings.append("\(i)")
        }
        return strings
    }
    
    var cfuProxy: Binding<Int> {
        Binding<Int>(get: {
            cfu
        }, set: {
            self.cfu = $0
            self.deltas = calculateDeltas(withCfu: $0)
        })
    }

    var gainedCfu: Double {
        courses.filter { course in course.mark != 0 }.compactMap { Double($0.cfu) }.reduce(0, { $0 + $1 })
    }

    var average: Double {
        let average = courses.filter { course in course.mark != 0 }.compactMap { Double($0.cfu) * Double($0.mark) }.reduce(0, { $0 + $1 })
        return average / gainedCfu
    }
    
    var body: some View {
        List {
            Section(header: Text("Course CFU"),
                    footer: Text("TWAY")) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(cfu)")
                        .font(.system(size: 50.0, weight: .bold, design: .rounded))
                        .padding()
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Stepper("", value: cfuProxy, in: 1...30)
                        .labelsHidden()
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            
            Section(header: Text("Current average")) {
                Text("\(average.twoDecimalPrecision)").bold()
            }
            
            Section(header: Text("New average")) {
                ForEach(deltas.indices, id: \.self) { index in
                    HStack {
                        Text(valueStrings[index])
                        Spacer()
                        Text("\(deltas[index].twoDecimalPrecision)")
                            .foregroundColor(deltas[index] < average ? .red : .green)
                    }
                }
            }
            
        }
        .singleSeparator()
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            self.deltas = calculateDeltas(withCfu: cfu)
            UIScrollView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().backgroundColor = UIColor(named: "background")
            UITableView.appearance().separatorStyle = .none
        }
        
        .navigationBarTitle("Delta Calculator")
    }

    public func calculateDeltas(withCfu cfu: Int) -> [Double] {
        var deltas = [Double]()
        let average = courses.filter { $0.mark != 0 }.map { Double($0.mark * $0.cfu) }.reduce(0, { $0 + $1 })
        let gainedCfu = Double(self.gainedCfu) + Double(cfu)

        guard gainedCfu != 0 else {
            for mark in 18...30 {
                deltas.append(Double(mark))
            }

            return deltas
        }

        var tmp = 0.0
        for mark in 18...30 {
            tmp = average
            tmp += (Double(mark) * Double(cfu))
            tmp /= gainedCfu
            deltas.append(tmp)
        }

        return deltas
    }
    
}

struct AverageDeltaTool_Previews: PreviewProvider {
    static var previews: some View {
        AverageDeltaTool()
            .colorScheme(.dark)
    }
}
