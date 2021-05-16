//
//  Home.swift
//  cornerStore
//
//  Created by Deesha Desai on 18/03/21.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        ZStack{
            
            VStack(spacing: 10) {
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showSideBar.toggle()}
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.blue)
                    })
                    
                    Text("The Corner Store")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal,.top])
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                    TextField("Search", text: $HomeModel.search)
                     
                    
                }
                .padding(.horizontal)
                .padding(.top, 10)
                Divider()
              
                if HomeModel.items.isEmpty{
                                    
                                    Spacer()
                                    
                                    ProgressView()
                                    
                                    Spacer()
                                }
                else{
                ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
                    VStack(spacing: 25) {
                        
                        ForEach(HomeModel.filteredItems){item in
                            
                            ZStack(alignment: Alignment(horizontal:.trailing, vertical: .top), content: {
                                    ItemView(item: item, homeData: HomeModel)
                                HStack{
                                    
                                    
                                    
                                    Button(action: {
                                        HomeModel.addToCart(item: item)
                                    }, label: {
                                        
                                        Image(systemName: item.isAdded ?"checkmark": "plus")
                                        .foregroundColor(.white)
                                        .padding(10)
                                            .background(item.isAdded ? Color.green: Color.blue)
                                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    })
                                }
                                
                                .padding(.trailing,20)
                                .padding(.top, 10)
                                
                                
                                Divider()
                                
                            })
                            .frame(width: UIScreen.main.bounds.width-30)
                            
                        }
                    }
                    .padding(.top, 10)
                })
            }
                Divider()
                HStack(spacing: 15){
                    Text(HomeModel.userLocation == nil ? "Locating.." : "Deliver To")
                        .foregroundColor(.black)
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                }
            }
            
            //Side menu
            
            HStack{
                    SideBar(homeData: HomeModel)
                        //mMove effect from left
                        .offset(x: HomeModel.showSideBar ? 0: -UIScreen.main.bounds.width / 1.6)
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .background(
                Color.black.opacity(HomeModel.showSideBar ? 0.3 : 0).ignoresSafeArea()
                //close when tapped outside
                    .onTapGesture(perform: {
                        withAnimation(.easeIn){HomeModel.showSideBar.toggle()}
                    })
            )
            // Non Closable alert if  permission denied
            
            if HomeModel.noLocation{
                Text("Please enable location access in settings to move on!!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        .onAppear(perform: {
                    //calling location delegate
                    HomeModel.locationManager.delegate = HomeModel
                   
                })
        .onChange(of: HomeModel.search, perform: { value in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                
                if value == HomeModel.search && HomeModel.search != ""{
                    
                    //Search Data....
                    HomeModel.filterItems()
                    
                }
            }
            
            if HomeModel.search == "" {
                //reset
                withAnimation(.linear){  HomeModel.filteredItems = HomeModel.items }
              
            }
        })
        }
    }





