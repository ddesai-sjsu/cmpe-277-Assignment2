//
//  Cart.swift
//  cornerStore
//
//  Created by Deesha Desai on 19/03/21.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item:Item
    var quantity: Int
}
   
