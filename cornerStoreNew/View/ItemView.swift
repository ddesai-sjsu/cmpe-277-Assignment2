//
//  ItemView.swift
//  cornerStore
//
//  Created by Deesha Desai on 19/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    var item: Item
    @ObservedObject var homeData: HomeViewModel
    var body: some View {
       
        VStack {
            //Donwloading Image From Web
            WebImage(url: URL(string: item.image))
                .resizable()
                .frame(width:UIScreen.main.bounds.width-30, height:250,alignment: .topLeading)
            HStack(spacing: 8){
            
                Text(item.name)
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.black)
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                //Ratings
                
                ForEach(1...5, id: \.self){ index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.ratings) ?? 0 ?
                                            .blue: .gray)
                }
                
            }
            
            HStack{
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                Text(homeData.getPrice(value: Float(truncating: item.cost)))
                    .font(.title2)
                    .foregroundColor(.black)
                

                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            Divider()
                .foregroundColor(.blue)
        }
        
        
        
        
    }
}
