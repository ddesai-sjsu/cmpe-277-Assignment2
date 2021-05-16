//
//  ContentView.swift
//  cornerStore
//
//  Created by Deesha Desai on 18/03/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
        Home()
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
