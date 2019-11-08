//
//  ContentView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 30/09/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct LandingView: View {
    
    @State private var landingViewIndex: Int = 0
    @Binding var isCardShown: Bool
    
    private let titles: [String] = [
        "Welcome to UniRadar",
        "Add scores",
        "Make predictions"
    ]
    
    private let headlines: [String] = [
        "A tool to manage every university task",
        "Manage all your scores in one place",
        "Predict how much you'll take in each exam"
    ]
    
    var body: some View {
        
        VStack {
    
            if landingViewIndex == 0 {
                LandingPage(title: titles[0], headline: headlines[0], imageName: "")
            } else if landingViewIndex == 1 {
                LandingPage(title: titles[1], headline: headlines[1], imageName: "")
            } else if landingViewIndex == 2 {
                LandingPage(title: titles[2], headline: headlines[2], imageName: "")
            }
            
            DotProgressBar(biggerCircleIndex: $landingViewIndex, isCardShown: $isCardShown)
                .padding()
                .animation(.easeIn)
            
        }.gesture(
            DragGesture()
                .onEnded { action in
                    if action.translation.width > 50.0 && self.landingViewIndex > 0 {
                        self.landingViewIndex -= 1
                    } else if action.translation.width < -50.0 && self.landingViewIndex < 2 {
                        self.landingViewIndex += 1
                    }
                }
        )
    }
}



struct LandingPage: View {
    
    var title: String
    var headline: String
    var imageName: String
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 350, height: 350, alignment: .center)
            
            Spacer()
            
            VStack(spacing: 10) {
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(headline)
                    .font(.system(size: 18))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

            }
            
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2))
        
    }
    
}

struct DotProgressBar: View {
    
    @Binding var biggerCircleIndex: Int
    @Binding var isCardShown: Bool
    
    var body: some View {
        HStack {
            
            Button(action: {
                if self.biggerCircleIndex > 0 {
                    self.biggerCircleIndex -= 1
                }
            }) {
                Text("Prev")
                    .foregroundColor(.black)
                    .padding(.leading, 30)
            }
            
            Spacer()
            
            Circle()
                .frame(
                    width: biggerCircleIndex == 0 ? 8 : 5,
                    height: biggerCircleIndex == 0 ? 8 : 5
                )
                .foregroundColor(.gray)
            
            Circle()
                .frame(
                    width: biggerCircleIndex == 1 ? 8 : 5,
                    height: biggerCircleIndex == 1 ? 8 : 5
                )
                .foregroundColor(.gray)
            
            Circle()
                .frame(
                    width: biggerCircleIndex == 2 ? 8 : 5,
                    height: biggerCircleIndex == 2 ? 8 : 5
                )
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                if self.biggerCircleIndex < 2 {
                    self.biggerCircleIndex += 1
                } else if self.biggerCircleIndex == 2 {
                    self.isCardShown = false
                }
            }) {
                Text("Next")
                    .foregroundColor(self.biggerCircleIndex == 2 ? .blue : .black)
                    .padding(.trailing, 30)
            }
            
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    @State static var isCardShownText: Bool = true
    
    static var previews: some View {
        LandingView(isCardShown: $isCardShownText)
    }
}
