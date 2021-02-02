//
//  ContentView.swift
//  Shared
//
//  Created by Alex lavallee on 1/24/21.
//

import SwiftUI



struct ContentView: View {
    let randomLong = Int.random(in: Int.min..<Int.max)
    var body: some View {
        VStack {
            Text("Random Hider")
                .font(.title)
                .padding()
            hideView(seed: String(randomLong))
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

