//
//  CartView.swift
//  cornerStore
//
//  Created by Deesha Desai on 19/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        
        VStack{
            
            HStack(spacing: 20){
                
                Button(action: {present.wrappedValue.dismiss()}) {
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.blue)
                }
                
                Text("My cart")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(spacing: 0){
                    
                    ForEach(homeData.cartItems){cart in

                        // Cart ItemView....
                        
                        HStack(spacing: 15){
                            
                            WebImage(url: URL(string: cart.item.image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(cart.item.name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(cart.item.description)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack(spacing: 15){
                                    
                                    Text(homeData.getPrice(value: Float(truncating: cart.item.cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    
                                    // Add - Sub Button...
                                    
                                    Button(action: {
                                        if cart.quantity > 1{
                                            homeData.cartItems[homeData.getIndex(item: cart.item,isCartIndex: true)].quantity -= 1
                                            
                                        }
                                    }) {
                                        
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .background(Color.black.opacity(0.06))
                                    
                                    Button(action: {
                                            
                                        homeData.cartItems[homeData.getIndex(item: cart.item,isCartIndex: true)].quantity += 1
                                        
                                    }) {
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding()
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .contextMenu{
                            
                            // for deleting order....
                            Button(action: {
                                // deleting items from cart....
                                let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                
                                let filterIndex = homeData.filteredItems.firstIndex { (item1) -> Bool in
                                    return cart.item.id == item1.id
                                } ?? 0
                                
                                homeData.items[itemIndex].isAdded = false
                                homeData.filteredItems[filterIndex].isAdded = false
                                
                                homeData.cartItems.remove(at: index)
                            }) {
                                
                                Text("Remove")
                            }
                        }
                    }
                }
            }
            
            // Bottom View...
            
            VStack{
                
                HStack{
                    
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // calculating Total Price...
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top,.horizontal])
                
                Button(action: homeData.updateOrder) {
                    
                    Text(homeData.ordered ? "Cancel Order" : "Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
            .background(Color.white)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
