//
//  HomeView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 13/04/2020.
//  Copyright © 2020 Mattia Righetti. All rights reserved.
//

import SwiftUI
import CoreData

struct MainView: View {
    @AppStorage("firstAccess") public var firstAccess: Bool = true
    @AppStorage("initialSetup") public var initialSetup: Bool = true

    @ObservedObject private var sheet = SheetState()
    
    @State var showSheet: Bool = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CoursesView()
                .tabItem {
                    Image(systemName: "archivebox")
                    Text("Courses")
                }
            
            ExamsView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Exams")
                }
            
            RemindersView()
                .tabItem {
                    Image(systemName: "pin")
                    Text("Assignments")
                }
        }
        .sheet(isPresented: $sheet.isShowing, onDismiss: presentationLogic, content: sheetContent)
        .onAppear {
            if firstAccess {
                sheet.state = .introduction
            } else if initialSetup {
                sheet.state = .initialForm
            }
        }
    }

    func presentationLogic() -> Void {
        if sheet.state == .introduction {
            firstAccess = false
            sheet.state = .initialForm
        } else if sheet.state == .initialForm {
            initialSetup = false
            sheet.state = .none
        }
    }

    @ViewBuilder private func sheetContent() -> some View {
        switch sheet.state {
        case .introduction:
            IntroductionView()
        case .initialForm:
            InitialForm()
        case .none:
            EmptyView()
        }
    }
}

fileprivate class SheetState: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var state: SheetContent = .none {
        didSet {
            isShowing = state != .none
        }
    }
}


fileprivate enum SheetContent {
    case none
    case initialForm
    case introduction
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .colorScheme(.dark).accentColor(Color.red)
    }
}
