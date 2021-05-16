//
//  CartViewModel.swift
//  cornerStore
//
//  Created by Deesha Desai on 19/03/21.
//

import SwiftUI

class CartViewModel: ObservableObject {
    
    @Published var items = [
        Item(id: "QpnjpolkomUjcE3xp8SK", item_name: "Chicken Carbonara", item_cost: 35, item_details:"Chicken Carbonara is full of indulgent bacon flavor and smothered in a cheesy egg sauce with juicy tender chicken added in. ", item_image: "https://thestayathomechef.com/wp-content/uploads/2021/02/Easy-Chicken-Carbonara-1.jpg", item_ratings:"5" ),
        Item(id: "B4R8jw0FQWLk5SxonzYB", item_name: "Tomato Avacado Salad", item_cost: 35, item_details:"Chicken Carbonara is full of indulgent bacon flavor and smothered in a cheesy egg sauce with juicy tender chicken added in. ", item_image: "https://thestayathomechef.com/wp-content/uploads/2020/12/Tomato-Avocado-Salad-1.jpg", item_ratings:"5" )
    ]
}

