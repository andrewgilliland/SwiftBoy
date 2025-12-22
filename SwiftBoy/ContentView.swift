//
//  ContentView.swift
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/20/25.
//

import SwiftUI
import GameBoy

struct ContentView: View {
    var body: some View {
        let result = 5
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(result)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
