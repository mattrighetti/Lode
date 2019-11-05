//
//  LoginView.swift
//  UniRadar
//
//  Created by Mattia Righetti on 05/11/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("UR")
                        .font(.custom("Avenir Next Regular", size: 35))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 25)
                
                Spacer()
            }
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("Welcome to")
                        .font(.custom("Avenir Next Regular", size: 55))
                        .foregroundColor(.gray)
                    Text("UniRadar")
                        .font(.custom("Avenir Next Regular", size: 55))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
            
            Spacer()
            Spacer()
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("A new way of managing your")
                        .font(.custom("Avenir Next Regular", size: 20))
                        .foregroundColor(.gray)
                    Text("university tasks")
                        .font(.custom("Avenir Next Regular", size: 20))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
            
            Spacer()
            Spacer()
            
            HStack(alignment: .center) {
                
                Button(action: { print("Login") }) {
                    
                    ZStack {
                        
                        Text("Log in")
                        .padding(.horizontal, 90)
                        .padding(.vertical)
                        .font(.custom("Avenir Next Regular", size: 24.0))
                        .foregroundColor(Color.white)
                        .background(
                            Color(red: 28/255, green: 28/255, blue: 29/255)
                        )
                        .cornerRadius(18)
                        
                    }
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Button(action: { print("Login") }) {
                    
                    Image(systemName: "faceid")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(
                            Color.flatBlack
                        )
                    
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                
            }
            
            Button(action: { print("Register") }) {
    
                Text("Register")
                    .padding(.horizontal, 120)
                    .padding(.vertical)
                    .font(.custom("Avenir Next Regular", size: 24.0))
                    .foregroundColor(Color.white)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.flatLightRed, Color.flatDarkRed]),
                                       startPoint: UnitPoint(x: 0.5, y: 0.0),
                                       endPoint: UnitPoint(x: 0.5, y: 1.0))
                    )
                    .cornerRadius(18)
                
            }.padding()
            
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
