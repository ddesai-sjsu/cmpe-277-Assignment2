//
//  SideBar.swift
//  cornerStore
//
//  Created by Deesha Desai on 18/03/21.
//

import SwiftUI

struct SideBar: View {
    @ObservedObject var homeData: HomeViewModel
    var body: some View {
        VStack{
            NavigationLink(destination: CartView(homeData: homeData)){
                HStack(spacing: 15) {
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                .padding()
            }
            
            Spacer()
            HStack {
                Spacer()
                
                Text("Version 1.0")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
            }
            .padding(10)
        }
        .padding([.top,.trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

