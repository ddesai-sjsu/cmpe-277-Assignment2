//
//  Item.swift
//  cornerStore
//
//  Created by Deesha Desai on 19/03/21.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var name: String
    var cost: NSNumber
    var description: String
    var image: String
    var ratings: String
    var isAdded: Bool = false
}
