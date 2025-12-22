//
//  ContentView.swift
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let result = SwiftBoyBridge.addA(2, b: 3)
        
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
